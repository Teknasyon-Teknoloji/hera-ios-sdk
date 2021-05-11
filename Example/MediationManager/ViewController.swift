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
	case inAppTransitionBanner
}

final class ViewController: UIViewController, HeraDelegate {

	private lazy var adsContainer: UIView = {
		let view = UIView()
		return view
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupBannerView()
		// You need to "ALWAYS" observe in viewDidAppear to keep the observer
		// active for only the current visible screen.
		Hera.shared.observeEvents(for: self)
		loadAd(.banner, action: .inAppTransitionBanner)
		loadAd(.interstitial, action: .mainScreen)
	}
	
	private func setupBannerView() {
		self.view.addSubview(adsContainer)
		adsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		adsContainer.widthAnchor.constraint(equalToConstant: 320).isActive = true
		adsContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
		adsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	private func loadAd(_ type: AdType, action: AdAction) {
		// This func is async and will notify about the result through the delegate
		// methods
		Hera.shared.loadAd(ofType: type, action: action.rawValue)
	}
	
	func heraDidLoadAd(for action: String, adType: AdType) {
		switch adType {
		case .banner:
			// Pass `UIView` instance for banner ads
			Hera.shared.showAd(ofType: .banner, action: action, on: adsContainer)
		case .interstitial:
			// Pass `UIViewController` instance for interstitial ads
			Hera.shared.showAd(ofType: .interstitial, action: action, on: self)
		}
	}
	
	func heraDidFailToLoadAd(for action: String, adType: AdType, error: Error) {
		print(adType, error.localizedDescription)
	}

	func heraDidFailToIntialize(error: Error) { }
	func heraDidShowAd(for action: String, adType: AdType) { }
	func heraDidFailToShowAd(for action: String, adType: AdType, error: Error) { }
	func heraDidDismissAd() { }
}
