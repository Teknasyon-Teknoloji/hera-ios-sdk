//
//  AMRProvider.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import UIKit
import AMRSDK

final class AMRProvider: NSObject, AdsProvider {

	var adEventHandler: ((AdEvent) -> Void)?
	
	private let appID: String
	private var banner: AMRBanner!
	private var interstitial: AMRInterstitial!
	private var rewarded: AMRRewardedVideo!
	
    private var bannerAction: String = ""
    private var interstitialAction: String = ""
    private var rewardedAction: String = ""
    
    var setUserConsent: Bool {
        didSet {
            AMRSDK.setUserConsent(setUserConsent)
        }
    }
    
    var subjectToGDPR: Bool {
        didSet {
            AMRSDK.subject(toGDPR: subjectToGDPR)
        }
    }
    
    var subjectToCCPA: Bool {
        didSet {
            AMRSDK.subject(toCCPA: subjectToCCPA)
        }
    }
    
	init(
		appID: String,
		setUserConsent: Bool,
		subjectToGDPR: Bool,
		subjectToCCPA: Bool
	) {
		self.appID = appID
		self.setUserConsent = setUserConsent
		self.subjectToGDPR = subjectToGDPR
		self.subjectToCCPA = subjectToCCPA
		super.init()
		start()
	}
    
    func loadBanner(id: String, keywords: String?, action: String) {
        banner = AMRBanner(forZoneId: id)
        banner.bannerWidth = 320 
        banner.delegate = self
        banner.load()
        bannerAction = action
        banner.viewController = UIApplication.topViewController()
    }
    
    func loadInterstitial(id: String, keywords: String?, action: String) {
		if let inter = interstitial, inter.isLoading {
			adEventHandler?(.didFailToLoad(action: action, adType: .interstitial, error: HeraError.anotherOperationInProgress))
            return
        }
        interstitial = AMRInterstitial(forZoneId: id)
        interstitial.delegate = self
        interstitial.load()
        interstitialAction = action
    }
    
    func loadRewarededVideo(id: String, keywords: String?, action: String) {
        rewarded = AMRRewardedVideo(forZoneId: id)
        rewarded.delegate = self
        rewarded.load()
        rewardedAction = action
    }
    
    func loadNative(id: String, keywords: String?, action: String) {
        fatalError("unsupported ad format")
    }
    
	func showBanner(on view: UIView) {
		guard view.window != nil else {
            bannerDidFailToShow(HeraError.viewDoesNotHaveVisibleUIWindow)
            return
        }
		
		guard banner != nil, banner.bannerView != nil else {
			bannerDidFailToShow(HeraError.nilBanner)
			return
		}
		
        view.addSubview(banner.bannerView)
    }
    
    func showInterstitial(on vc: UIViewController) {
        if let interstitial = interstitial {
            interstitial.show(from: vc)
        }
    }
    
    func showRewarededVideo(on vc: UIViewController) {
        Logger.log(.warning, "unsupported ad format")
    }
    
    func showNative(on vc: UIViewController) {
        Logger.log(.warning, "unsupported ad format")
        
    }
	
	func forceHideBanner() {
		if banner != nil {
			banner.bannerView.removeFromSuperview()
			banner.bannerView = nil
			banner = nil
		}
	}
}

fileprivate extension AMRProvider {
	func start() {
		AMRSDK.setUserConsent(setUserConsent)
		AMRSDK.subject(toGDPR: subjectToGDPR)
		AMRSDK.subject(toCCPA: setUserConsent)
        AMRSDK.start(withAppId: appID)
        AMRBannerView.observeLifeCycles()
        BannerStateObserver.bannerDidShowHandler = bannerDidShow
        BannerStateObserver.bannerDidFalilToShowHandler = bannerDidFailToShow(_:)
	}
}

// MARK: Banner Delegate
extension AMRProvider: AMRBannerDelegate {
	func didReceive(_ banner: AMRBanner!) {
		adEventHandler?(.didLoad(action: bannerAction, adType: .banner))
	}
	
	func didClick(_ banner: AMRBanner!) {
		adEventHandler?(.clicked)
	}
	
	func didFail(toReceive banner: AMRBanner!, error: AMRError!) {
		adEventHandler?(.didFailToLoad(action: bannerAction, adType: .banner, error: error))
	}
	
    func bannerDidShow() {
        adEventHandler?(.didShow(action: bannerAction, adType: .banner))
    }
    
    func bannerDidFailToShow(_ error: Error) {
        adEventHandler?(.didFailToShow(action: bannerAction, adType: .banner, error: error))
    }
}

// MARK: Interstitial Delegate
extension AMRProvider: AMRInterstitialDelegate {
	func didReceive(_ interstitial: AMRInterstitial!) {
		self.interstitial = interstitial
		adEventHandler?(.didLoad(action: interstitialAction, adType: .interstitial))
	}
	
	func didFail(toReceive interstitial: AMRInterstitial!, error: AMRError!) {
		adEventHandler?(.didFailToLoad(action: interstitialAction, adType: .interstitial, error: error))
	}
	
	func didClick(_ interstitial: AMRInterstitial!) {
		adEventHandler?(.clicked)
	}
	
	func didShow(_ interstitial: AMRInterstitial!) {
		adEventHandler?(.didShow(action: interstitialAction, adType: .interstitial))
	}
	
	func didFail(toShow interstitial: AMRInterstitial!, error: AMRError!) {
		adEventHandler?(.didFailToShow(action: interstitialAction, adType: .interstitial, error: error))
	}
	
	func didDismiss(_ interstitial: AMRInterstitial!) {
		adEventHandler?(.dismissed)
	}
}

// MARK: Rewarded Video Delegate
extension AMRProvider: AMRRewardedVideoDelegate {
	func didReceive(_ rewardedVideo: AMRRewardedVideo!) {
        // adEventHandler?(.didLoad(action: rewardedAction))
	}
	
	func didFail(toReceive rewardedVideo: AMRRewardedVideo!, error: AMRError!) {
		// adEventHandler?(.didFailToLoad(action: rewardedAction, error: error))
	}
	
	func didClick(_ rewardedVideo: AMRRewardedVideo!) {
		adEventHandler?(.clicked)
	}
	
	func didShow(_ rewardedVideo: AMRRewardedVideo!) {
		// adEventHandler?(.didShow(action: rewardedAction))
	}
	
	func didFail(toShow rewardedVideo: AMRRewardedVideo!, error: AMRError!) {
        // adEventHandler?(.didFailToShow(action: rewardedAction, error: error))
	}
	
	func didDismiss(_ rewardedVideo: AMRRewardedVideo!) {
		// adEventHandler?(.dismissed)
	}
}

// MARK: Native Ad Delegate
extension AMRProvider: AMRNativeAdBaseViewDelegate {
	
	func didDismissNativeInterstitial() {
		adEventHandler?(.dismissed)
	}
}

extension AMRError: Error { }
extension AMRError: LocalizedError {}
