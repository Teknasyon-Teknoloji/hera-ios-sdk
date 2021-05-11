//
//  AdOperation.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 15.04.2021.
//

import Foundation

/// A type that represents an ad operation. Each ad load
/// request is considered as operation.
struct AdOperation: Hashable {
	
	/// The action associated with each ad.
	let action: String
	
	/// The ad type.
	let adType: AdType
}
