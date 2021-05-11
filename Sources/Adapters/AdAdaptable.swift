//
//  AdAdaptable.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 18.01.2021.
//

import UIKit

/// Represents the type that can  load ads.
protocol AdLodable {
	/// Logs back all the possible events of an add.
	var adEventHandler: ((AdEvent) -> Void)? { get set }
	
    /// Load ad of type banner with the specified id.
    /// - Parameter id: the banner unit id.
    func loadBanner(id: String, keywords: String?, action: String)
    
    /// Load ad of type interstitial( with the specified id.
    /// - Parameter id: the intersitial ad unit id.
    func loadInterstitial(id: String, keywords: String?, action: String)
    
    /// Load ad of type rewarded video with the specified id.
    /// - Parameter id: the rewarded video unit id.
    func loadRewarededVideo(id: String, keywords: String?, action: String)
    
    /// Loads ad of type native with the specifed id.
    /// - Parameter id: the native ad unit id/
    func loadNative(id: String, keywords: String?, action: String)
    
	/// Force stop banner ads.
	func forceHideBanner() 
	
    var setUserConsent: Bool { get set }
    var subjectToGDPR: Bool { get set }
    var subjectToCCPA: Bool { get set }
}

/// Represents the type that can  show ads.
protocol AdShowable {
	
	/// Shows the loaded ad on the specifed view controller.
	/// - Parameters:
    ///     - vc: A view controller instance that wanted to be showing ads.
	///     - adType: The ad type see `AdType` for more info.
    // func show(adType type: AdType, on vc: UIViewController)
    
    /// Shows ad of type banner with the specified id.
    /// - Parameter vc: A view controller instance that wanted to be showing ads.
    func showBanner(on view: UIView)
    
    /// Shows ad of type interstitial( with the specified id.
    /// - Parameter vc: A view controller instance that wanted to be showing ads.
    func showInterstitial(on vc: UIViewController)
    
    /// Shows ad of type rewarded video with the specified id.
    /// - Parameter vc: A view controller instance that wanted to be showing ads.
    func showRewarededVideo(on vc: UIViewController)
    
    /// Shows ad of type native with the specifed id.
    /// - Parameter vc: A view controller instance that wanted to be showing ads.
    func showNative(on vc: UIViewController)
}

/// Represents the type that can both show and load ads
typealias AdsProvider = AdLodable & AdShowable
