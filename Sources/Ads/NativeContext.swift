//
//  NativeContext.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 8.10.2021.
//

import Foundation

/// A container for the native ads, it groups together the real native ad view alongside
/// its configuration and the action for that ad.
struct NativeContext<Ad: AnyObject & Equatable>: Equatable {
	
	/// The real native ad view object that hold the rendered elements.
	let view: Ad
	
	/// The native ad configuration object.
	let config: NativeAdConfig
	
	/// The action assocaited with this ad.
	let action: String
}
