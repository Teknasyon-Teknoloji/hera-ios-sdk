//
//  JSON.swift
//  HeraTests
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import Foundation
@testable import Hera

// swiftlint:disable force_try
func makeDataFromJSON(_ json: [String: Any]) -> Data {
	return try! JSONSerialization.data(withJSONObject: json)
}

func makeConfig(from json: [String: Any] = configJson) -> Config {
	let data = makeDataFromJSON(json)
	return try! JSONDecoder().decode(Config.self, from: data)
}


let configJson: [String: Any] = [
	"provider": "admost",
	"provider_token": "123456",
	"first_ad_time": 10,
	"ad_interval": 5,
	"actions":
		[
			"test": [
				"type": "banner",
				"unit_id": "12345",
				"keywords": nil,
				"ignore_timer": false
			]
	]
]
