//
//  HeraError.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 25.01.2021.
//

import Foundation

/// A type encloses all the possible errors thrown by the SDK.
public enum HeraError: Swift.Error {
    case falidToLoad
    case outOfTimeInterval
	case betweenTwoAdsInterval
    case actionDoesNotMatch
    case anotherOperationInProgress
    case notCongiguredProperly
	case wrongAppID
    case anotherAdIsBeingShown
	case wrongPresenterType
}

extension HeraError: CustomStringConvertible, LocalizedError {
    public var description: String {
        switch self {
        case .falidToLoad:
			return "Failed to load the add"
			
        case .outOfTimeInterval:
			return "Cant show the add at the moment because the time interval since startup is less than the configured."
			
        case .actionDoesNotMatch:
			return "The provided action doesn't any of the fetched actions. Please make sure you provided the right action name (case-sensetive)."
			
        case .anotherOperationInProgress:
			return "Trying to load ad while another load operation is in progress. Please wait!"
			
        case .notCongiguredProperly: return "The Manager is misconfigured, make sure you have called both initialize(apiKey: environment:) and setUserProperties(_:) with the right parameters consequently."
			
		case .betweenTwoAdsInterval:
			return "Cant show the add at the moment because the time interval since the last shown ad is less than the configured."
			
		case .wrongAppID:
			return "The provider ID is incorrect."
            
        case .anotherAdIsBeingShown:
            return "Can show add for now because another ad is being shown 🔫"
		case .wrongPresenterType:
			return "You are either trying to present interstial on a UIView or presenting banner on UIViewController. Make sure you have used the right presenter type"
		}
    }

    public var errorDescription: String? {
        description
    }
}
