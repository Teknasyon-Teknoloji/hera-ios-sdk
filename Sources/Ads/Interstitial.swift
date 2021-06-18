//
//  Interstitial.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 7.04.2021.
//

import Foundation

/// An instnace representing thInterstitial ads.
final class Interstitial: HeraAd {
    var state: AdState = .hidden
    var lastLoadingDate: Date?
	var lastShowingDate: Date?
}
