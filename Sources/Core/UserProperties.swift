//
//  UserProperties.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import Foundation

public struct HeraUserProperties: Encodable {
	public typealias AttributionAgentInfo = [String: String]
	
    public let deviceID: String
	public let country: String
    public let language: String?
	public let advertiseAttributions: AttributionAgentInfo
    public let deviceType: String
    public var extraData: [String: Codable]
    
	public init(
	deviceID: String,
	country: String,
	language: String?,
	deviceType: String = "",
	advertiseAttributions: AttributionAgentInfo,
	extraData: [String: Codable]
	) {
		self.deviceID = deviceID
		self.country = country
        self.language = language
        self.deviceType = deviceType
		self.advertiseAttributions = advertiseAttributions
        self.extraData = extraData
	}
    
    enum CodingKeys: String, CodingKey {
        case device_id
        case country
        case language
        case device_type
        case advertise_attributions
        case extra_data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceID, forKey: .device_id)
        try container.encode(country, forKey: .device_id)
        try container.encode(language, forKey: .device_id)
        try container.encode(advertiseAttributions, forKey: .device_id)
        try container.encode(deviceType, forKey: .device_id)
        let jsonData = try JSONEncoder().encode(extraData)
        try container.encode(jsonData, forKey: .extra_data)
    }
}

// Temporarty solution
extension HeraUserProperties {
    func toJSON() -> [String: Any] {
        [
            "platform": "ios",
            "advertise_attributions": advertiseAttributions,
            "device_id": deviceID,
            "country": country,
            "language": language,
            "device_type": "",
            "extra_data": extraData
        ]
    }
}
