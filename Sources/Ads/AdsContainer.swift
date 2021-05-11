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
}

// MARK: - Helpers
extension AdsContainer {
    
    func setShowingDate(_ date: (() -> Date) = { Date() }, for adType: AdType) {
        switch adType {
        case .interstitial:
            self.interstitial.lastShowingDate = date()
        case .banner:
            self.banner.lastShowingDate = date()
        }
    }
    
    func setLoadingDate(_ date: (() -> Date) = { Date() }, for adType: AdType) {
        switch adType {
        case .interstitial:
            self.interstitial.lastLoadingDate = date()
        case .banner:
            self.banner.lastLoadingDate = date()
        }
    }
    
    func ad(ofType type: AdType) -> HeraAd {
        switch type {
        case .banner: return banner
        case .interstitial: return interstitial
        }
    }
    
    func setState(for type: AdType, from event: AdEvent) {
        switch type {
        case .interstitial:
            self.interstitial.state = event.mapToAdState()
        case .banner:
            self.banner.state = event.mapToAdState()
        }
    }
    
    func setState(_ state: AdState, for type: AdType) {
        switch type {
        case .interstitial:
            self.interstitial.state = state
        case .banner:
            self.banner.state = state
        }
    }
}
