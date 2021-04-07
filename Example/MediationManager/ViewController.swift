//
//  ViewController.swift
//  Hera
//
//  Created by engali94 on 01/20/2021.
//  Copyright (c) 2021 engali94. All rights reserved.
//

import UIKit
import Hera

enum AdAction: String {
	case settings
	case mainScreen
}

final class ViewController: UIViewController, HeraDelegate {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// You need to "ALWAYS" observe in viewDidAppear to keep the observer
		// active for only the current visible screen.
		Hera.shared.observeEvents(for: self)
		loadAd(action: .mainScreen)
	}
	
	private func loadAd(action: AdAction) {
		// This func is async and will notify about the result through the delegate
		// methods
		Hera.shared.loadAd(ofType: .interstitial, action: action.rawValue)
	}
		
	func heraDidLoadAd(for action: String, adType: AdType) {
		Hera.shared.showAd(ofType: adType, action: action, on: self)
	}
	
	func heraDidFailToLoadAd(for action: String, adType: AdType, error: Error) {
		print(error.localizedDescription)
	}
	func heraDidShowAd(for action: String) { }
	func heraDidFailToShowAd(for action: String, error: Error) { }
	func heraDidDismissAd() { }
	func heraDidFailToIntialize(error: Error) { }
	
}
