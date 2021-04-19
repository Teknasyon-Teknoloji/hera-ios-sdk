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
		banner = MPAdView(adUnitId: id)
		banner.delegate = self
		banner.keywords = keywords
		banner.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
		bannerAction = action
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
		view.addSubview(banner)
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
	}
}

// MARK: Banner Delegate
extension MobupProvider: MPAdViewDelegate {
	func viewControllerForPresentingModalView() -> UIViewController! {
		// it depends on when it is called
		vcForPresentingModalView
	}
	
	func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
		adEventHandler?(.didLoad(action: bannerAction))
	}
	
	func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
		adEventHandler?(.didFailToLoad(action: bannerAction, error: error))
	}
}

extension MobupProvider: MPInterstitialAdControllerDelegate {
	func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
		self.interstitial = interstitial
		adEventHandler?(.didLoad(action: interstitialAction))
	}
	
	func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
		adEventHandler?(.didFailToLoad(action: interstitialAction, error: error))
	}
	
	func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.didShow(action: interstitialAction))
	}
	
	func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.dismissed)
	}
	
	func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
		adEventHandler?(.clicked)
	}
}
