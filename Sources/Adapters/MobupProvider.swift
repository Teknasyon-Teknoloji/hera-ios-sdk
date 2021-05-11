//
//  MobupProvıder.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 19.01.2021.
//

import UIKit
import MoPubSDK

final class MobupProvider: NSObject, AdsProvider {
	var adEventHandler: ((AdEvent) -> Void)?

	private weak var vcForPresentingModalView: UIViewController?
	private var banner: MPAdView!
	private var interstitial: MPInterstitialAdController!
	private var rewarded: MPRewardedAds!
	
	private let adUnitID: String
	
	private var bannerAction: String = ""
	private var interstitialAction: String = ""
	private var rewardedAction: String = ""
	
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
		banner.delegate = self
		banner.keywords = keywords
        banner.loadAd(withMaxAdSize: .init(width: UIScreen.main.bounds.width, height: 50))
		bannerAction = action
		banner.forceRefreshAd()
	}
	
	func loadInterstitial(id: String, keywords: String?, action: String) {
		// Mobup tries to reach main UIWindow's frame and calling
		// [UIView init] method on background thread, which should
		// be only called on Main thread.
		DispatchQueue.main.async {
			self.interstitial = MPInterstitialAdController(forAdUnitId: id)
			self.interstitial.delegate = self
			self.interstitial.keywords = keywords
			self.interstitial.loadAd()
			self.interstitialAction = action
            
		}
	}
	
	func loadRewarededVideo(id: String, keywords: String?, action: String) {
		rewardedAction = action
		fatalError("unimplemented, reserved for future use.")
	}
	
	func loadNative(id: String, keywords: String?, action: String) {
		fatalError("unimplemented, reserved for future use.")
	}
	
	func showBanner(on view: UIView) {
	
        guard view.window != nil else {
            bannerDidFailToShow(HeraError.viewDoesNotHaveVisibleUIWindow)
            return
        }
        
		guard banner != nil else {
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
	
	func showRewarededVideo(on vc: UIViewController) {
		Logger.log(.warning, "unimplemented, reserved for future use.")
	}
	
	func showNative(on vc: UIViewController) {
		Logger.log(.warning, "unimplemented, reserved for future use.")
	}
	
	func forceHideBanner() {
		if banner != nil {
			banner.removeFromSuperview()
			banner.stopAutomaticallyRefreshingContents()
			banner = nil
		}
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
        banner.frame.size.height = view.frame.height
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
