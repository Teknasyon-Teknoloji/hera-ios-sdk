//
//  AdType.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import Foundation

public enum AdType: String, Decodable {
	case interstitial
    
    // @available(*, unavailable, message: "Unsupported Ad type at the moment, choose another option")
	case banner
    
    @available(*, unavailable, message: "Unsupported Ad type at the moment, choose another option")
	case rewarededAd
    
    @available(*, unavailable, message: "Unsupported Ad type at the moment, choose another option")
	case nativeAd
}

struct AdUnit: Decodable {
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
}
