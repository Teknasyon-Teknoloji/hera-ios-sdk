//
//  Banner.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 7.04.2021.
//

import Foundation

/// A type representing the banner ad.
final class Banner: HeraAd {
    var state: AdState = .hidden
	var lastLoadingDate: Date?
	
	// NOTE: The banner always refreshes itself based on specific
	//  time intervals so we need to take this into considration.
    var lastShowingDate = Date()
}
