//
//  SerailQueueTests.swift
//  HeraTests
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import XCTest
@testable import Hera

final class SerailQueueTests: XCTestCase {
	
	func testAddingDuplicateActionsEnsureItAppearsOnlyOnce() {
		let queue = SerialQueue()
		
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		
		XCTAssertEqual(queue.operationsCount, 1)
	}
	
	func testAddingDifferentOperationsTheResultingCountIsTrue() {
		let queue = SerialQueue()
	
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		queue.add(operation: .init(action: "inAppTransition", adType: .banner))
		queue.add(operation: .init(action: "featureChange", adType: .interstitial))
		
		XCTAssertEqual(queue.operationsCount, 3)
	}
	
	func testDequeueReturnsTheRightElement() throws {
		let queue = SerialQueue()
		
		queue.add(operation: .init(action: "inAppTransition", adType: .interstitial))
		queue.add(operation: .init(action: "inAppTransition", adType: .banner))
		
		let op1 = try XCTUnwrap(queue.dispatch())
		XCTAssertEqual(op1, .init(action: "inAppTransition", adType: .interstitial))
		
		let op2 = try XCTUnwrap(queue.dispatch())
		XCTAssertEqual(op2, .init(action: "inAppTransition", adType: .banner))
	}
}
