//
//  MobupProvıder.swift
//  MediationManager
//
//  Created by Ali Ammar Hilal on 19.01.2021.
//

import UIKit
import MoPubSDK

final class MobupProvider: NSObject, AdsProvider {
	var adEventHandler: ((AdEvent) -> Void)?

	private weak var vcForPresentingModalView: UIViewController?
	private var banner: MPAdView?
	private var interstitial: MPInterstitialAdController?
	private var rewarded: MPRewardedAds?
    private var nativeAd: MPNativeAd?
    
	private let adUnitID: String
	
	private var bannerAction: String = ""
	private var interstitialAction: String = ""
	private var rewardedAction: String = ""
    private var nativeAction: String = ""
    private var nativeAdConfig: NativeAdConfig?
    
	private var natives: [NativeContext<MPNativeAd>] = []
	
	var setUserConsent: Bool = false {
		didSet {
			if setUserConsent {
				MoPub.sharedInstance().grantConsent()
			} else {
				MoPub.sharedInstance().revokeConsent()
			}
		}
	}
	
	var subjectToGDPR: Bool = false {
		didSet {
			if subjectToGDPR {
				MoPub.sharedInstance().forceGDPRApplicable()
			}
		}
	}
	
	var subjectToCCPA: Bool = false {
		didSet {
			
		}
	}
	
	init(adUnitID: String) {
		self.adUnitID = adUnitID
		super.init()
		start()
	}
	
	func loadBanner(id: String, keywords: String?, action: String) {
		banner = MPAdView(adUnitId: id) // 0ac59b0996d947309c33f59d6676399f
		banner?.delegate = self
		banner?.keywords = keywords
        // banner.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kMPPresetMaxAdSizeMatchFrame.height)
        banner?.loadAd(withMaxAdSize: .init(width: UIScreen.main.bounds.width, height: 50))
		bannerAction = action
		banner?.forceRefreshAd()
	}
	
	func loadInterstitial(id: String, keywords: String?, action: String) {
		// Mobup tries to reach main UIWindow's frame and calling
		// [UIView init] method on background thread, which should
		// be only called on Main thread.
		DispatchQueue.main.async {
			self.interstitial = MPInterstitialAdController(forAdUnitId: id)
			self.interstitial?.delegate = self
			self.interstitial?.keywords = keywords
			self.interstitial?.loadAd()
			self.interstitialAction = action
		}
	}
	
	func loadRewarededVideo(id: String, keywords: String?, action: String) {
		rewardedAction = action
		// rewarded = MPRewardedAds()
		MPRewardedAds.loadRewardedAd(withAdUnitID: id, withMediationSettings: [])
		MPRewardedAds.setDelegate(self, forAdUnitId: id)
	}

	func loadNative(id: String, keywords: String?, action: String, config: NativeAdConfig) {
        let settings = MPStaticNativeAdRendererSettings()
    
        settings.renderingViewClass = config.viewClass
        settings.viewSizeHandler = { (width) -> CGSize in
            return config.size
        }
        
		guard let renderingConfigs = MPStaticNativeAdRenderer.rendererConfiguration(with: settings, additionalSupportedCustomEvents: []) else { return }
        let adRequest = MPNativeAdRequest(adUnitIdentifier: id, rendererConfigurations: [renderingConfigs])
        adRequest?.start(completionHandler: { request, nativeAd, error in
            if let error = error {
                self.adEventHandler?(.didFailToLoad(action: action, adType: .native(config: config), error: error))
                return
            }
			guard let nativeAd = nativeAd else { return }
            self.nativeAd = nativeAd
            nativeAd.delegate = self
            let adView = try? nativeAd.retrieveAdView()
            adView?.frame = .init(origin: .zero, size: config.size)
            config.adView = adView
			self.natives.append(.init(view: nativeAd, config: config, action: action))
            self.adEventHandler?(.didLoad(action: action, adType: .native(config: config)))
        })
	}
	
	func showBanner(on view: UIView) {
        guard view.window != nil else {
            bannerDidFailToShow(HeraError.viewDoesNotHaveVisibleUIWindow)
            return
        }
        
		guard let banner = banner else {
			bannerDidFailToShow(HeraError.nilBanner)
			return
		}
		
        view.addSubview(banner)
        banner.fillSuperview()
	}
	
	func showInterstitial(on vc: UIViewController) {
		if let interstitial = interstitial, interstitial.ready {
			interstitial.show(from: vc)
		}
	}
	
	func showRewarededVideo(on vc: UIViewController, for unitID: String?) {
		MPRewardedAds.presentRewardedAd(forAdUnitID: unitID, from: vc, with: .init(currencyAmount: 0))
	}
	
	func showNative(on view: UIView) {
        guard let native = nativeAd, let adView =  try? native.retrieveAdView() else { return }
        view.addSubview(adView)
        adView.fillSuperview()
	}
	
	func forceHideBanner() {
		if banner != nil {
			banner?.removeFromSuperview()
			banner?.stopAutomaticallyRefreshingContents()
			banner = nil
		}
	}
	
	func checkRewardedAdsAvailability(forUnitID id: String) -> Bool {
		MPRewardedAds.hasAdAvailable(forAdUnitID: id)
	}
    
    func didHitTheLimitForRewarded(withAction action: String) -> Bool {
        false
    }
}

private extension MobupProvider {
	func start() {
		let configs = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
		if subjectToGDPR {
			MoPub.sharedInstance().forceGDPRApplicable()
		}
		MoPub.sharedInstance().initializeSdk(with: configs) {
			Logger.log(.success, "MoPub intialized successfully")
		}
        
        MPAdView.observeLifeCycles()
        BannerStateObserver.bannerDidShowHandler = bannerDidShow
        BannerStateObserver.bannerDidFalilToShowHandler = bannerDidFailToShow(_:)
	}
}

// MARK: Banner Delegate
extension MobupProvider: MPAdViewDelegate {
	
	func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        Logger.log(.debug, "Loaded ad size", adSize)
        banner?.frame.size.height = view.frame.height
		adEventHandler?(.didLoad(action: bannerAction, adType: .banner))
	}
	
	func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
		adEventHandler?(.didFailToLoad(action: bannerAction, adType: .banner, error: error))
	}
    
    func bannerDidShow() {
        adEventHandler?(.didShow(action: bannerAction, adType: .banner))
    }
    
    func bannerDidFailToShow(_ error: Error) {
        adEventHandler?(.didFailToShow(action: bannerAction, adType: .banner, error: error))
    }
}

extension MobupProvider: MPInterstitialAdControllerDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        // it depends on when it is called
        guard let viewController = vcForPresentingModalView else { return UIApplication.topViewController() }
        return viewController
    }
    
	func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
		self.interstitial = interstitial
		adEventHandler?(.didLoad(action: interstitialAction, adType: .interstitial))
	}
	
	func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
		adEventHandler?(.didFailToLoad(action: interstitialAction, adType: .interstitial, error: error))
	}
	
	func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.didShow(action: interstitialAction, adType: .interstitial))
	}
	
	func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.dismissed)
	}
	
	func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.clicked)
	}
}

// MARK: Rewarded Ads
extension MobupProvider: MPRewardedAdsDelegate {
	
	func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
		adEventHandler?(.didLoad(action: rewardedAction, adType: .rewarded))
	}
	
	func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
		adEventHandler?(.didFailToLoad(action: rewardedAction, adType: .rewarded, error: error))
	}
	
	func rewardedAdDidFailToShow(forAdUnitID adUnitID: String!, error: Error!) {
		adEventHandler?(.didFailToShow(action: rewardedAction, adType: .rewarded, error: error))
	}
	
	func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
		adEventHandler?(.didShow(action: rewardedAction, adType: .rewarded))
	}
	
	func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
		adEventHandler?(.dismissed)
	}
	
	func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
		adEventHandler?(.didReward)
	}
}

extension MobupProvider: MPNativeAdDelegate {}
