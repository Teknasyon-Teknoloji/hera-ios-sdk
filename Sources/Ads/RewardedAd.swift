//
//  RewardedAd.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 8.07.2021.
//

import Foundation

final class RewardedAd: HeraAd {
	var state: AdState = .hidden
	var lastLoadingDate: Date?
	var lastShowingDate: Date?	
}
