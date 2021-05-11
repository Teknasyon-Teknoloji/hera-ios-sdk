//
//  NetorkingTests.swift
//  HeraTests
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import Foundation
import XCTest
@testable import Hera

final class NetworkingTests: XCTestCase {
	
	func testInitDoesntPerformAnyRequest() {
		let sut = NetworkManagerMock()
		XCTAssertEqual(sut.requests, 0)
	}
	
	func testGetDeliversErrorOnNon200HTTPResponse() {
		let sut = NetworkManagerMock()

		let samples = [199, 201, 300, 400, 500]
		
		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: .failure(.invalidData), when: {
				let json = makeDataFromJSON([:])
				sut.fulfill(withStatusCode: code, data: json, at: index)
			})
		}
	}
	
	func testGetGivesInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
		let sut = NetworkManagerMock()
	
		expect(sut, toCompleteWith: .failure(.invalidData), when: {
			let invalidJSON = Data("invalid json".utf8)
			sut.fulfill(withStatusCode: 200, data: invalidJSON)
		})
	}
	
	func testGetGivesSuccessWithItemsOn200HTTPResponseWithJSONConfig() {
		let sut = NetworkManagerMock()
		let config = makeConfig()

		expect(sut, toCompleteWith: .success(config), when: {
			let json = makeDataFromJSON(configJson)
			sut.fulfill(withStatusCode: 200, data: json)
		})
	}
}

extension NetworkingTests {
	typealias Handler = ((Result<Config, Error>) -> Void)
	
	func expect(_ sut: Networking, toCompleteWith expectedResult: Result<Config, HeraError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for load completion")
		let userProps = HeraUserProperties(deviceID: "", country: "", language: "", advertiseAttributions: [:], extraData: [:])
		
		sut.getConfigs(userprops: userProps, appKey: "") { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedItems), .success(expectedItems)):
				XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

			case let (.failure(receivedError as HeraError), .failure(expectedError)):
				XCTAssertEqual(receivedError, expectedError, file: file, line: line)

			default:
				XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
			}

			exp.fulfill()
		}

		action()

		waitForExpectations(timeout: 0.1)
	}
}
