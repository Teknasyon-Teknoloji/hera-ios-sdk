//
//  AdEvent.swift
//  Hera
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
	case willDisappear// (action: String)
	case didDisappear// (action: String)
	case willPresentModal
	case didDismissModal
	case didExpire
	case clicked// (action: String)
	case dismissed// (action: String)
	case willLeaveApp
	case shouldRewardUser
	case didTrackImpression
}
