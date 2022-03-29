//
//  HeraError.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 25.01.2021.
//

import Foundation

/// A type encloses all the possible errors thrown by the SDK.
public enum HeraError: Swift.Error, Equatable {
    case falidToLoad(action: String)
    case invalidData
    case outOfTimeInterval
    case betweenTwoAdsInterval
    case actionDoesNotMatch(action: String, availableActions: String)
    case anotherOperationInProgress
    case notCongiguredProperly
    case wrongAppID
    case anotherAdIsBeingShown
    case wrongPresenterType
    case viewDoesNotHaveVisibleUIWindow
    case nilBanner
	case noAdsInventoryForAdType(AdType)
}

extension HeraError: CustomStringConvertible, LocalizedError {
    public var description: String {
        switch self {
        case .falidToLoad(let action):
            return "Failed to load the add for action: \(action)"
        case .invalidData:
            return "Invalid data, can't be decoded!"
        case .outOfTimeInterval:
            return "Cant show the add at the moment because the time interval since the app startup is less than the configured. Please wait"
        case .actionDoesNotMatch(let action, let fethcedActions):
            return "The provided action: (\(action) doesn't any of the fetched actions \(fethcedActions). Please make sure you provided the right action name (case-sensetive)."
        case .anotherOperationInProgress:
            return "Trying to load ad while another load operation is in progress. Please wait!"
        case .notCongiguredProperly:
            return "The fetched configs are invalid."
        case .betweenTwoAdsInterval:
            return "Cant show the add at the moment because the time interval since the last shown ad is less than the configured."
        case .wrongAppID:
            return "The provider ID is incorrect."
        case .anotherAdIsBeingShown:
            return "Can show add for now because another ad is being shown 🔫"
        case .wrongPresenterType:
            return "You are either trying to present interstial on a UIView or presenting banner on UIViewController. Make sure you have used the right presenter type"
        case .viewDoesNotHaveVisibleUIWindow:
            return "View does not have visible UIWindow"
        case .nilBanner:
            return "Banner instance is deallocated. Please load the banner before trying to show it."
		case .noAdsInventoryForAdType(let type):
			return "No Ads inventory for the ad placement of type: \(type)"
        }
    }
    
    public var errorDescription: String? {
        description
    }
}
