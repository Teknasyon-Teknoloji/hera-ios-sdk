//
//  NetworkManagerMock.swift
//  HeraTests
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import XCTest
import Foundation
@testable import Hera

class NetworkManagerMock: Networking {
	
	typealias Handler = ((Result<Config, Error>) -> Void)
	
	private var messages = [Handler]()
	
	var requests: Int {
		return messages.count
	}

	func getConfigs(userprops: HeraUserProperties, appKey: String, completion: @escaping Handler) {
		messages.append((completion))
	}

	func fulfill(withStatusCode code: Int, data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
		if (201...500).contains(code) {
			messages[index](.failure(HeraError.invalidData))
			return
		}
		
		guard requests > index else {
			return XCTFail("Can't complete request never made", file: file, line: line)
		}
		
		do {
			let config = try JSONDecoder().decode(Config.self, from: data)
			messages[index](.success(config))
		} catch {
			messages[index](.failure(HeraError.invalidData))
		}
		
	}
}
