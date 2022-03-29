//
//  AdsContainer.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 7.04.2021.
//

import Foundation

/// Current app's ads container
final class AdsContainer {

    /// Interstitial ad type
    var interstitial = Interstitial()
    
    /// Banner ad type
    var banner = Banner()
	
	/// Rewarded Ads
	var rewarded = RewardedAd()
    
    /// Rewarded Ads
    var native = Native()
}

// MARK: - Helpers
extension AdsContainer {
    
    func setShowingDate(_ date: (() -> Date) = { Date() }, for adType: AdType) {
		ad(ofType: adType).lastShowingDate = date()
    }
    
    func setLoadingDate(_ date: (() -> Date) = { Date() }, for adType: AdType) {
		ad(ofType: adType).lastLoadingDate = date()
    }
    
    func setState(for type: AdType, from event: AdEvent) {
		ad(ofType: type).state = event.mapToAdState()
    }
    
    func setState(_ state: AdState, for type: AdType) {
		ad(ofType: type).state = state
    }
	
	func ad(ofType type: AdType) -> HeraAd {
		switch type {
		case .banner: return banner
		case .interstitial: return interstitial
		case .rewarded: return rewarded
        case .native: return native
        }
	}
}
