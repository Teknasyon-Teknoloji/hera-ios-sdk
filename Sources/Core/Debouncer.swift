//
//  Debouncer.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.03.2021.
//

import Foundation

/// Runs load  action after delay
final class Debouncer {
	private let delay: TimeInterval
	private var workItem: DispatchWorkItem?
	private let queue: DispatchQueue

	init(delay: TimeInterval, queue: DispatchQueue = .main) {
		self.delay = delay
		self.queue = queue
	}

	func debounce(action: @escaping () -> Void) {
		workItem?.cancel()
		let workItem = DispatchWorkItem(block: action)
		queue.asyncAfter(deadline: .now() + delay, execute: workItem)
		self.workItem = workItem
	}
}
