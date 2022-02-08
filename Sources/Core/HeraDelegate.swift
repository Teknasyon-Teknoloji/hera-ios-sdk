//
//  HeraDelegate.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 21.01.2021.
//

import Foundation

public protocol HeraDelegate: AnyObject { 
	func heraDidLoadAd(for action: String, adType: AdType)
    func heraDidFailToLoadAd(for action: String, adType: AdType, error: Error)
    func heraDidDismissAd()
    func heraDidShowAd(for action: String, adType: AdType)
    func heraDidFailToShowAd(for action: String, adType: AdType, error: Error)
    func heraDidFailToIntialize(error: Error)
	func heraDidRewardUser()
}

public extension HeraDelegate {
    func heraDidDismissAd() {}
	func heraDidShowAd(for action: String, adType: AdType) {}
	func heraDidFailToShowAd(for action: String, adType: AdType, error: Error) {}
    func heraDidFailToIntialize(error: Error) {}
	func heraDidRewardUser() {}
}
