//
//  HeraDelegate.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 21.01.2021.
//

import Foundation

public protocol HeraDelegate: AnyObject { 
	func heraDidLoadAd(for action: String)
    func heraDidFailToLoadAd(for action: String, error: Error)
    func heraDidDismissAd()
    func heraDidShowAd(for action: String)
    func heraDidFailToShowAd(for action: String, error: Error)
    func heraDidFailToIntialize(error: Error)
}

public extension HeraDelegate {
    func heraDidDismissAd() {}
	func heraDidShowAd(for action: String) {}
	func heraDidFailToShowAd(for action: String, error: Error) {}
    func heraDidFailToIntialize(error: Error) {}
}
