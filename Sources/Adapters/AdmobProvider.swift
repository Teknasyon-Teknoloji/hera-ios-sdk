//
//  AdmobProvider.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 6.12.2021.
//

import Foundation
import GoogleMobileAds

final class AdmobProvider: NSObject, AdsProvider {
    
    private var bannerAction = ""
    private var interstitialAction = ""
    private var nativeAction = ""
    private var rewardedAction = ""
    
    var adEventHandler: ((AdEvent) -> Void)?
    
    var setUserConsent: Bool = false
    
    var subjectToGDPR: Bool = false
    
    var subjectToCCPA: Bool = false
    
    private var banner: GADBannerView?
    
    private var interstitial: GADInterstitialAd?
    
    private var native: GADAdLoader?
    
    private var rewarded: GADRewardedAd?

    private var natives: [NativeContext<GADAdLoader>] = []
    
    override init() {
        super.init()
        start()
    }
    
    func loadBanner(id: String, keywords: String?, action: String) {
        banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner?.adUnitID = id
        bannerAction = action
        banner?.rootViewController = UIApplication.topViewController()
        banner?.delegate = self
        banner?.load(GADRequest())
    }
    
    func loadInterstitial(id: String, keywords: String?, action: String) {
        let request = GADRequest()
        interstitialAction = action
        GADInterstitialAd.load(withAdUnitID: id,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            if let error = error {
				Logger.log(.error, "Admob mediation failed to load interstitial ad with error: \(error.localizedDescription)")
                self?.adEventHandler?(.didFailToLoad(action: action, adType: .interstitial, error: error))
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            self?.adEventHandler?(.didLoad(action: action, adType: .interstitial))
        })
    }
    
    func loadRewarededVideo(id: String, keywords: String?, action: String) {
        
        GADRewardedAd.load(withAdUnitID: id, request: GADRequest()) { [weak self] rewarded, error in
            if let error = error {
                Logger.log(.error, error.localizedDescription)
                return
            }
            self?.rewarded = rewarded
            self?.rewarded?.fullScreenContentDelegate = self
            self?.adEventHandler?(.didLoad(action: action, adType: .rewarded))
        }
    }
    
    func loadNative(id: String, keywords: String?, action: String, config: NativeAdConfig) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        // The number of ads to be loaded in this request
        multipleAdsOptions.numberOfAds = 1
        
        native = GADAdLoader(adUnitID: id, rootViewController: UIApplication.topViewController(),
                            adTypes: [.native],
                            options: [multipleAdsOptions])
        native?.delegate = self
        native?.load(GADRequest())
		natives.append(.init(view: native!, config: config, action: action))
    }
    
    func checkRewardedAdsAvailability(forUnitID id: String) -> Bool {
		Logger.log(.warning, "Not supported by Admob mediation")
		return true
    }
    
    func didHitTheLimitForRewarded(withAction action: String) -> Bool {
		Logger.log(.warning, "Not supported by Admob mediation")
		return false
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
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: vc)
        }
    }
    
    func showRewarededVideo(on vc: UIViewController, for unitID: String?) {
        if let rewarded = rewarded {
            rewarded.present(fromRootViewController: vc) { [weak self] in
                self?.adEventHandler?(.didReward)
            }
        }
    }
    
    func showNative(on view: UIView) {
        Logger.log(.debug, "Unimplemented")
    }
    
    func forceHideBanner() {
        banner?.removeFromSuperview()
        banner = nil
		
    }
}

private extension AdmobProvider {
    func start() {
        let ads = GADMobileAds.sharedInstance()
        ads.start { status in
            let adapterStatuses = status.adapterStatusesByClassName
            for adapter in adapterStatuses {
                let adapterStatus = adapter.value
                Logger.log(.debug, "Adapter Name: \(adapter.key), Description: \(adapterStatus.description), Latency: \(adapterStatus.latency)")
            }
        }
        #if DEBUG
        ads.requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
        #endif
    }
}

// MARK: - Banner
extension AdmobProvider: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.banner = bannerView
        adEventHandler?(.didLoad(action: bannerAction, adType: .banner))
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        adEventHandler?(.didFailToLoad(action: bannerAction, adType: .banner, error: error))
    }
    
    func bannerDidShow() {
        adEventHandler?(.didShow(action: bannerAction, adType: .banner))
    }
    
    func bannerDidFailToShow(_ error: Error) {
        adEventHandler?(.didFailToShow(action: bannerAction, adType: .banner, error: error))
    }
}

// MARK: - Interstitial
extension AdmobProvider: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if ad as? GADRewardedAd != nil {
            adEventHandler?(.didFailToShow(action: rewardedAction, adType: .rewarded, error: error))
        } else {
            adEventHandler?(.didFailToShow(action: interstitialAction, adType: .interstitial, error: error))
        }
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if ad as? GADRewardedAd != nil {
            adEventHandler?(.didShow(action: rewardedAction, adType: .rewarded))
        } else {
            adEventHandler?(.didShow(action: interstitialAction, adType: .interstitial))
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            if ad as? GADRewardedAd != nil {
                adEventHandler?(.dismissed(action: rewardedAction, adType: .rewarded))
            } else {
                adEventHandler?(.dismissed(action: interstitialAction, adType: .interstitial))
            }
        
    }
}

extension AdmobProvider: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
		if let native = natives.first(where: { $0.view == adLoader }) {
			adEventHandler?(.didLoad(action: nativeAction, adType: .native(config: native.config)))
		} else {
			Logger.log(.error, "Something went wrong with native ads...")
		}
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
		if let native = natives.first(where: { $0.view == adLoader }) {
			adEventHandler?(.didFailToLoad(action: nativeAction, adType: .native(config: native.config), error: error))
		} else {
			Logger.log(.error, error.localizedDescription)
		}
    }
}
