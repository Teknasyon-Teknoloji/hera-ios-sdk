//
//  AdType.swift
//  MediationManager
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import Foundation

public enum AdType: Equatable, Hashable {
	case interstitial
	case banner
	case rewarded
    case native(config: NativeAdConfig)
}

struct AdUnit: Decodable, Equatable {
	let type: AdType
	let unitID: String
	let keywords: String?
	let ignoreTimer: Bool?
	
	enum CodingKeys: String, CodingKey {
		case type
		case unitID = "unit_id"
		case keywords
		case ignoreTimer = "ignore_timer"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let typeString = try values.decode(String.self, forKey: .type)
		if let type = InternalAdType(rawValue: typeString) {
            self.type = type.mapToAdType()
		} else {
			fatalError("faild to decode \(typeString)")
		}
		unitID = try values.decode(String.self, forKey: .unitID)
		keywords = try values.decodeIfPresent(String.self, forKey: .keywords)
		ignoreTimer = try values.decodeIfPresent(Bool.self, forKey: .ignoreTimer)
	}
    
    private enum InternalAdType: String, Equatable {
        case interstitial
        case banner
        case rewarded
        case native
        
        func mapToAdType() -> AdType {
            switch self {
            case .banner: return .banner
            case .interstitial: return .interstitial
            case .rewarded: return .rewarded
            case .native: return .native(config: NativeAdConfig(nibName: "", viewClass: DefaultNativeRenderer.self, size: .zero))
            }
        }
    }
}
