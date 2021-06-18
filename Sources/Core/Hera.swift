//
//  hera.swift
//  hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import UIKit
import Foundation

public final class Hera {
	private(set) public var apiKey: String?
    
    private(set) public var environment: HeraEnvironment = .sandbox
    
	private(set) public var isUserConsentSet: Bool = false
	private(set) public var isSbjectToGDPR: Bool  = false
	private(set) public var isSubjectToCCPA: Bool  = false

	private var userProperties: HeraUserProperties?
    
	private var adsProvider: AdsProvider?
    
	private var config: Config?
    
	private let networkingManager: Networking
    
    var intializationDate = Date()
            
	var isInterstialAdShowing = false
	
    weak var delegate: HeraDelegate?
    
    /// A singleton instance of `hera`
    public static let shared = Hera()
	
	/// A  serial queue to hold all the ads load operations
    private let queue: SerialQueue
    
    /// The container of the all supported ads.
    private(set) var adContainer = AdsContainer()

	/// Init the medation manager wih default properties
	/// - Parameters:
	///   - userProperties: An object of type `MediationUserProperties`
	///   - adsProvider: An object conforming to `AdsProvider` protocol.
	///   - networkingManager: An object conforming to  `Networking` protocol.
	internal init(
		userProperties: HeraUserProperties? = nil,
		adsProvider: AdsProvider? = nil,
		networkingManager: Networking = NetworkManager(),
		queue: SerialQueue  = SerialQueue()
	) {
		self.userProperties = userProperties
		self.adsProvider = adsProvider
		self.networkingManager = networkingManager
		self.queue = queue
	}
	
	/// Initializes the medation mananager with the given API key and environment type.
	/// - Parameters:
	///   - apiKey: The app specific API key  of type string.
	///   - userProperties: An object of type `HeraUserProperties`
	///   - environment: The current app environment of type `MediationEnvironment`.
	public func initialize(
		apiKey: String,
		userProperties: HeraUserProperties,
		environment: HeraEnvironment
	) {
		self.apiKey = apiKey
		self.environment = environment
		self.userProperties = userProperties
		self.intializationDate = Date()
		configure()
	}
	
    /// Updates the user premium and landing dismissal count, calling this method will trigger
    /// a configuratio fetch request.
    /// - Parameter extraData: An extra json object to be passed to the backend. *WARNING*:
	///  `is_premium` and ` landing_loading_count` are compulsary.
	public func updateUserStatus(extraData: [String: Codable], completion: @escaping(Result<Void, Error>) -> Void ) {
        userProperties?.extraData = extraData
        configure(completion: completion)
	}
	
	/// Sets the user consents
	/// - Parameter value: A  boolean flag whether the current user consent is set or not.
	public func setUserConsent(_ value: Bool) {
		isUserConsentSet = value
        adsProvider?.setUserConsent = value
	}
		
	/// Whether the user subjects to CCPA rules
	/// - Parameter value: A  boolean flag whether the current user subjects to CCPA  or not.
    public func setSubjectToCCPA(_ value: Bool) {
		isSubjectToCCPA = value
		adsProvider?.subjectToCCPA = value
	}
	
	/// Sets observer for `heraNotifierDelegate`events.
	/// - Parameter observer: An object conforming to `heraNotifierDelegate` protocol.
	public func observeEvents(for observer: HeraDelegate) {
		delegate = observer
        // notifier.addObserver(observer)
	}
	
	/// Reomves the `heraNotifierDelegate`observer.
	/// - Parameter observer: An object conforming to `heraNotifierDelegate` protocol.
	public func removeObserver(for observer: HeraDelegate) {
		 delegate = nil
        // notifier.removeObserver(observer)
	}
	
	/// Loads the ad according to the action passed to the function, If the no corsponding ad is not found
	/// or the time interval critira is not met it will trigger different events according to the situation.
	/// - Parameters:
	///   - adType: The type of the ad to be loaded. see `AdType`
	///   - action: the action associated with the ad type.
	public func loadAd(ofType adType: AdType, action: String) {
		do {
            try prepareToLoad(adType: adType, action: action)
			queue.add(operation: AdOperation(action: action, adType: adType))
			Logger.log(.debug, "The \(adType) for \(action) set to waiting, no: \(queue.operationsCount)")
			loadIfPossible()
		} catch {
			notifiyObserver { $0?.heraDidFailToLoadAd(for: action, adType: adType, error: error) }
		}
	}
	
	/// Shows the ad according to the action passed to the function, If the no corsponding ad is not found
	/// it will return without any effect.
	/// - Parameters:
	///   -  action: the action needs to be performed.
	///   - type: Ad type
	///   - controller: The controller to present ads on it,
	public func showAd(ofType type: AdType, action: String, on presenter: AdsPresenter) {
		guard
			let config = config,
			let adsProvider = adsProvider else {
			self.notifiyObserver { $0?.heraDidFailToIntialize(error: HeraError.notCongiguredProperly) }
			return
		}
		
        if type != .banner {
            do {
                try checkTimeInterval(from: config, andAction: action, type: type)
                
            } catch let error {
                notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: type, error: error) }
                return
            }
        }
		
		if type == .interstitial && (adContainer.interstitial.state == .showning || isInterstialAdShowing) {
            Logger.log(.debug, "Trying to show ad while another ad is being shown.")
            self.notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: type, error: HeraError.anotherAdIsBeingShown) }
            return
        }
        
        Logger.log(.debug, "Will show ad of type \(type) and action \(action)")
        
		guard let adType = config.actions[action]?.type, type == adType else {
			let avaliableActions = config.actions.map({ $0.key }).joined(separator: ", ")
			self.notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: type, error: HeraError.actionDoesNotMatch(action: action, availableActions: avaliableActions)) }
			return
		}
		
		DispatchQueue.main.async {
			switch adType {
			case .interstitial:
				guard let controller = presenter.adsViewController else {
					self.notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: adType, error: HeraError.wrongPresenterType)}
					return
				}
				adsProvider.showInterstitial(on: controller)
			case .banner:
				guard let view = presenter.adsView else {
					self.notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: adType, error: HeraError.wrongPresenterType)}
					return
				}
				adsProvider.showBanner(on: view)
			case .rewarededAd:
				break
			case .nativeAd:
				break
			}
		}
	}
	
	/// Removes and stops banner automatic refreshing
	/// if you want to hide banner calling this method wil hide
	/// it and remove it from super view permanently.
	public func removeBanner() {
		adsProvider?.forceHideBanner()
	}
}

private extension Hera {
	typealias ConfigHandler = ((Result<Config, Swift.Error>) -> Void)
	
	/// Makes a network request to the Mediation backend and configures the manager
	///  according to the  returned response,
	/// - Parameter completion: A completion handler to be called after the response
	///   retturned
    func configure(completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let props = userProperties,
              let  apiKey = apiKey else {
            Logger.log(.error, """
            The Manager is misconfigured, make sure you have
            called both initialize(apiKey: environment:) and
            setUserProperties(_:) with the right parameters
            consequently.
            """)
			completion?(.failure(HeraError.notCongiguredProperly))
            return
        }
        
		fetchConfigs(apiKey: apiKey, userProps: props) { result in
			switch result {
			case .success(let config):
				self.config = config
                self.adsProvider = self.provider(from: config)
                Logger.log(.success, "hera successfully intialized with \(config.provider) provider.")
                completion?(.success(()))
                self.ovserveEvents()
				self.setSbjectToGDPR()
			case .failure(let error):
                Logger.log(.error, "hera has not been intialized \(error.localizedDescription)")
                self.adsProvider = nil
                completion?(.failure(error))
			}
		}
	}
	
	/// Makes a network request to the Mediation backend and configures the manager
	///  according to the  returned response,
	/// - Parameters:
	///   - apiKey: The app api key
	///   - userProps: current user properties
	///   - completion:  A completion handler to be called after the response
	///   retturned
	func fetchConfigs(apiKey: String, userProps: HeraUserProperties, completion: @escaping ConfigHandler) {
		guard let props = userProperties else {
			Logger.log(.error, "Hera is misconfigured, make sure you have called setUserProperties(_:) with the right parameters.")
			completion(.failure(HeraError.notCongiguredProperly))
			return
		}
		
		networkingManager.getConfigs(userprops: props, appKey: apiKey, completion: completion)
	}
	
	/// Extracts the provider from the backend configs
	/// - Parameter config: The config object returned by the backend
	/// - Returns: An instance of `AdsProvider`
	func provider(from config: Config) -> AdsProvider? {
		switch config.provider {
		case .admost:
			guard let appId = config.providerID, appId.count == 36  else {
				notifiyObserver { $0?.heraDidFailToIntialize(error: HeraError.wrongAppID )}
				return nil
			}
			return AMRProvider(appID: appId, setUserConsent: isUserConsentSet, subjectToGDPR: isSbjectToGDPR, subjectToCCPA: isSubjectToCCPA)
		case .mopub:
            guard let unitID = config.actions.values.first?.unitID else { return nil }
            return MobupProvider(adUnitID: unitID)
		case .none: return nil
		}
	}
	
	/// Observes different events that happen in `adsProvider` and notifies
	/// the client observer about it.
	func ovserveEvents() {
		adsProvider?.adEventHandler = { [weak self] event in
			guard let self = self else { return }
			Logger.log(.debug, "Hera Did Recived Event: \(event)")
			switch event {
			case let .didLoad(action, adType):
                self.handleLoad(of: adType, with: action)
                self.adContainer.setState(for: adType, from: event)
			case let .didFailToLoad(action, adType, error):
                self.handleLoadFailure(of: adType, with: action, and: error)
                self.adContainer.setState(for: adType, from: event)
			case let .didShow(action, adType):
                self.handleShow(of: adType, with: action)
                self.adContainer.setState(for: adType, from: event)
			case .dismissed:
                self.handleAdDismissal()
                self.adContainer.setState(for: .interstitial, from: event)
			case let .didFailToShow(action, adType, error):
                self.handleShowFailure(of: adType, with: action, and: error)
                self.adContainer.setState(for: adType, from: event)
			default: ()
			}
		}
	}
	
	/// Checks the time interval since startup or the time interval between two ads according to the backend configs.
	/// - Parameters:
	///   - config: An object representing the backend configs.
	///   - action: The action associated with the ad.
	///   - type: The ad type.
	/// - Throws: An error of type `HeraError` if the interval criteria is not met.
	func checkTimeInterval(from config: Config, andAction action: String, type: AdType) throws {
		if let ignoreTimer = config.actions[action]?.ignoreTimer, ignoreTimer == true { return }
        
        if Date().timeIntervalSince(intializationDate) <= config.firstTimeout {
            throw HeraError.outOfTimeInterval
        }
        
		guard let date = adContainer.ad(ofType: type).lastShowingDate else { return }
        if Date().timeIntervalSince(date) <= config.adInterval {
            throw HeraError.betweenTwoAdsInterval
		}
	}
	
	// swiftlint:disable large_tuple
	@discardableResult
	func prepareToLoad(adType: AdType, action: String) throws -> (config: Config, provifer: AdsProvider, adID: String) {
		guard
			let config = self.config,
			let adsProvider = self.adsProvider else {
			throw HeraError.notCongiguredProperly
		}
		
		guard let adId = config.actions[action]?.unitID else {
			let avaliableActions = config.actions.map({ $0.key }).joined(separator: ", ")
			throw HeraError.actionDoesNotMatch(action: action, availableActions: avaliableActions)
		}
		
		try self.checkTimeInterval(from: config, andAction: action, type: adType)
        
        if let date = adContainer.ad(ofType: adType).lastLoadingDate, Date().timeIntervalSince(date) >= 10 {
            adContainer.setState(.loadingTimedOut, for: adType)
        }
        
        try checkLoadingState(ofType: adType)
        
		return (config, adsProvider, adId)
	}
	
    func checkLoadingState(ofType ad: AdType) throws {
        switch ad {
        case .banner:
            if adContainer.banner.state == .loading { throw HeraError.anotherOperationInProgress }
        case .interstitial:
            if adContainer.interstitial.state == .loading { throw HeraError.anotherOperationInProgress }
        }
    }
    
	func loadNext() {
		loadIfPossible()
	}
	
    func loadIfPossible() {
        guard let operation = queue.dispatch() else { return }
        let action = operation.action
        let adType = operation.adType
        do {
            let (config, adsProvider, adId) = try prepareToLoad(adType: adType, action: action)
            let keywords = config.actions[action]?.keywords
            
			self.adContainer.setLoadingDate(for: adType)
            self.adContainer.setState(for: adType, from: .willLoad)
            
            Logger.log(.debug, "Will Load ad of type \(adType) for action \(action)")
            
            switch operation.adType {
            case .interstitial:
                adsProvider.loadInterstitial(id: adId, keywords: keywords, action: action)
            case .banner:
                adsProvider.loadBanner(id: adId, keywords: keywords, action: action)
            case .rewarededAd:
                adsProvider.loadRewarededVideo(id: adId, keywords: keywords, action: action)
            case .nativeAd:
                adsProvider.loadNative(id: adId, keywords: keywords, action: action)
            }
        } catch {
            notifiyObserver { $0?.heraDidFailToLoadAd(for: action, adType: adType, error: error)}
        }
    }
    
	/// Whether the user subjects to GDPR rules or not.
	func setSbjectToGDPR() {
		let value = Locale.current.regionCode?.isSubjectToGDBR ?? false
		isSbjectToGDPR = value
		adsProvider?.subjectToGDPR = value
	}
	
	///  Ensure All the events are delivered on the main thread only.
	/// - Parameter event: An event of from `heraNotifierDelegate`.
	func notifiyObserver(_ event: @escaping(HeraDelegate?) -> Void) {
		DispatchQueue.main.async {
            event(self.delegate)
            // self.notifier.sendEvent(event)
		}
	}
    
    func handleLoad(of adType: AdType, with action: String) {
        self.notifiyObserver { $0?.heraDidLoadAd(for: action, adType: adType) }
		loadNext()
    }
    
    func handleLoadFailure(of adType: AdType, with action: String, and error: Error) {
        self.notifiyObserver { $0?.heraDidFailToLoadAd(for: action, adType: adType, error: error) }
		loadNext()
    }
    
    func handleShow(of adType: AdType, with action: String) {
		if adType == .interstitial {
			self.isInterstialAdShowing = true
		}
        // We need to set it in this place in order to prevent other
		// ads from being showed before the current ad is closed
		self.adContainer.setShowingDate(for: adType)
        self.notifiyObserver { $0?.heraDidShowAd(for: action, adType: adType) }
    }
    
    func handleShowFailure(of adType: AdType, with action: String, and error: Error) {
		if adType == .interstitial {
			self.isInterstialAdShowing = false
		}
		
        self.notifiyObserver { $0?.heraDidFailToShowAd(for: action, adType: adType, error: error) }
    }
    
    func handleAdDismissal() {
		self.isInterstialAdShowing = false
		self.adContainer.setShowingDate(for: .interstitial)
        self.notifiyObserver { $0?.heraDidDismissAd() }
    }
}
