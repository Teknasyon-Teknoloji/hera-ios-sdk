//
//  IronSourceProvider.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 2.11.2021.
//

import UIKit
import ISWrapper

final class IronSourceProvider: NSObject, AdsProvider {
	var adEventHandler: ((AdEvent) -> Void)?
	
	var setUserConsent: Bool = false
	
	var subjectToGDPR: Bool = false
	
	var subjectToCCPA: Bool = false
	
	private var bannerAction: String = ""
	private var interstitialAction: String = ""
	private var rewardedAction: String = ""

	private var banner: ISBannerView?
	
	init(appID: String) {
		super.init()
		start(withAppID: appID)
	}
	
	private func start(withAppID id: String) {
		IronSource.setInterstitialDelegate(self)
		IronSource.setBannerDelegate(self)
		IronSource.setRewardedVideoDelegate(self)
		ISIntegrationHelper.validateIntegration()
		IronSource.initWithAppKey(id)
	}

	func loadBanner(id: String, keywords: String?, action: String) {
		bannerAction = action
		IronSource.loadBanner(with: UIApplication.topViewController() ?? .init(nibName: nil, bundle: nil), size: ISBannerSize(description: "HERA_BANNER", width: 320, height: 50))
	}
	
	func loadInterstitial(id: String, keywords: String?, action: String) {
		IronSource.loadInterstitial()
		interstitialAction = action
	}
	
	func loadRewarededVideo(id: String, keywords: String?, action: String) {
		rewardedAction = action
		if IronSource.hasRewardedVideo() {
			Logger.log(.debug, "Will load rewarded video as from IronSource")
			// Note: ironSource SDK is automatically caching Rewarded
			// Videos, to make sure you have ad availability, through
			// the entire session. so we can notify the client about
			// the ads availability immediatly at this point.
			adEventHandler?(.didLoad(action: action, adType: .rewarded))

		} else {
			adEventHandler?(.didFailToLoad(action: action, adType: .rewarded, error: HeraError.noAdsInventoryForAdType(.rewarded)))
		}
	}
	
	func loadNative(id: String, keywords: String?, action: String, config: NativeAdConfig) {
		
	}
	
	func forceHideBanner() {
		guard let banner = banner else {
			return
		}

		IronSource.destroyBanner(banner)
	}
	
	func showBanner(on view: UIView) {
		guard let banner = banner else { return }
		guard view.window != nil else {
			adEventHandler?(.didFailToShow(action: bannerAction, adType: .banner, error: HeraError.viewDoesNotHaveVisibleUIWindow))
			return
		}
		
		view.addSubview(banner)
		banner.fillSuperview()
	}
	
	func showInterstitial(on vc: UIViewController) {
		IronSource.showInterstitial(with: vc)
	}
	
	func showRewarededVideo(on vc: UIViewController, for unitID: String?) {
        IronSource.showRewardedVideo(with: vc)
	}
	
	func showNative(on view: UIView) {
		
	}
	
	func checkRewardedAdsAvailability(forUnitID id: String) -> Bool {
        IronSource.hasRewardedVideo()
	}

    func didHitTheLimitForRewarded(withAction action: String) -> Bool {
        IronSource.isRewardedVideoCapped(forPlacement: action)
    }
}

extension IronSourceProvider: ISInterstitialDelegate {
	func interstitialDidLoad() {
		adEventHandler?(.didLoad(action: interstitialAction, adType: .interstitial))
	}
	
	func interstitialDidFailToLoadWithError(_ error: Error!) {
		adEventHandler?(.didFailToLoad(action: interstitialAction, adType: .interstitial, error: error))
	}
	
	func interstitialDidOpen() {
		adEventHandler?(.willAppear)
	}
	
	func interstitialDidClose() {
		adEventHandler?(.dismissed)
	}
	
	func interstitialDidShow() {
		adEventHandler?(.didShow(action: interstitialAction, adType: .interstitial))
	}
	
	func interstitialDidFailToShowWithError(_ error: Error!) {
		adEventHandler?(.didFailToShow(action: interstitialAction, adType: .interstitial, error: error))
	}
	
	func didClickInterstitial() {
		adEventHandler?(.clicked)
	}
}

extension IronSourceProvider: ISRewardedVideoDelegate {
	func rewardedVideoHasChangedAvailability(_ available: Bool) {
		Logger.log(.debug, "IronSource Rewarded Video available: \(available)")
		if available {
			// adEventHandler?(.didLoad(action: rewardedAction, adType: .rewarded))
		} else {
			adEventHandler?(.didFailToLoad(action: rewardedAction, adType: .rewarded, error: HeraError.noAdsInventoryForAdType(.rewarded)))
		}
	}
	
	func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
		adEventHandler?(.didReward)
	}
	
	func rewardedVideoDidFailToShowWithError(_ error: Error!) {
		adEventHandler?(.didFailToShow(action: rewardedAction, adType: .rewarded, error: error))
	}
	
	func rewardedVideoDidOpen() {
		adEventHandler?(.didShow(action: rewardedAction, adType: .rewarded))
	}
	
	func rewardedVideoDidClose() {
		adEventHandler?(.dismissed)
	}
	
	func rewardedVideoDidStart() {
		
	}
	
	func rewardedVideoDidEnd() {
		
	}
	
	func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
		adEventHandler?(.clicked)
	}
}

extension IronSourceProvider: ISBannerDelegate {
	func bannerDidLoad(_ bannerView: ISBannerView!) {
		// banner?.frame.size.height = bannerView.frame.height
		adEventHandler?(.didLoad(action: bannerAction, adType: .banner))
	}
	
	func bannerDidFailToLoadWithError(_ error: Error!) {
		adEventHandler?(.didFailToLoad(action: bannerAction, adType: .banner, error: error))
	}
	
	func didClickBanner() {
		
	}
	
	func bannerWillPresentScreen() {
		
	}
	
	func bannerDidDismissScreen() {
		
	}
	
	func bannerWillLeaveApplication() {
		
	}
	
	func bannerDidShow() {
		adEventHandler?(.didShow(action: bannerAction, adType: .banner))
	}
}
