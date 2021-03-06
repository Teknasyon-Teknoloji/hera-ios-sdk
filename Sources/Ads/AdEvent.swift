//
//  AdEvent.swift
//  MediationManager
//
//  Created by Ali Ammar Hilal on 20.01.2021.
//

import Foundation

/// Possible ad events
public enum AdEvent {
	case didLoad(action: String, adType: AdType)
    case didFailToLoad(action: String, adType: AdType, error: Error)
	case didShow(action: String, adType: AdType)
	case didFailToShow(action: String, adType: AdType, error: Error)
	case didFailToPlay
	case willAppear
	case didAppear
	case willDisappear // (action: String)
	case didDisappear(action: String)
	case willPresentModal
	case didDismissModal
	case didExpire
	case clicked // (action: String)
	case dismissed(action: String, adType: AdType)
	case willLeaveApp
	case shouldRewardUser
	case didTrackImpression
    case willLoad
	case didReward
	case newAdImpression(AdImpression)
}

extension AdEvent {
    
    /// Maps the curent ad event to its corrsponding ad state
    /// - Returns: an object of type `AdState`
    func mapToAdState() -> AdState {
        switch self {
        case .didLoad: return .loaded
        case .didShow: return .showning
        case .willLoad: return .loading
        case .dismissed, .didFailToShow, .didFailToLoad: return .hidden
        default: return .unknown
        }
    }
}
