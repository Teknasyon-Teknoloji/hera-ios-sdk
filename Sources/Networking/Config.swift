//
//  Config.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import Foundation

struct Config: Decodable, Equatable {
	let provider: Provider
	let providerID: String?
	let actions: [String: AdUnit]
	let firstTimeout: TimeInterval
	let adInterval: TimeInterval
	
	enum CodingKeys: String, CodingKey {
		case provider = "provider"
		case providerID = "provider_token"
		case firstTimeOut = "first_ad_time"
		case adInterval = "ad_interval"
		case actions = "actions"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		provider = try values.decode(Provider.self, forKey: .provider)
		providerID = try values.decodeIfPresent(String.self, forKey: .providerID)
		actions = try values.decode([String: AdUnit].self, forKey: .actions)
		firstTimeout = try values.decode(TimeInterval.self, forKey: .firstTimeOut)
		adInterval = try values.decode(TimeInterval.self, forKey: .adInterval)
	}
}
