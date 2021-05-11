//
//  SerialQueue.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import Foundation

/// A type that wraps ad operation and covert them to serail
/// operations that can be dispatched and executed serially.
final class SerialQueue {
	
	/// A queue that holds the operation to be executed by keeping them ordered.
	private var uniqueQueue = NSOrderedSet().mutableCopy() as? NSMutableOrderedSet
	
	/// Represents the current operations count that are waiting to be processed.
	var operationsCount: Int {
		uniqueQueue?.count ?? 0
	}
	
	/// Appends `AdOperation` instance to the serial queue.
	/// - Parameter operation: Ad operation instance.
	func add(operation: AdOperation) {
		uniqueQueue?.add(operation)
	}
	
	/// Dispaches the  first element of the queue to be executed.
	/// - Returns: An instance of `AdOperation` or `nil` if empty.
	func dispatch() -> AdOperation? {
		guard (uniqueQueue?.count ?? 0) > 0 else { return nil }
		defer { uniqueQueue?.removeObject(at: 0) }
		return uniqueQueue?.firstObject as? AdOperation
	}
}
