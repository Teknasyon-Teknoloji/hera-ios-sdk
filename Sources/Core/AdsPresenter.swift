//
//  AdsPresenter.swift
//  Hera
//
//  Created by Ali A. Hilal on 6.04.2021.
//

import UIKit

///
/// `AdsPresenter` is a type-erased  (`UIViewController` & `UIView`) that
///  can be used as an abstraction from a specific presenter class to show ads.
///
public protocol AdsPresenter {
	
	/// A container view to present banner ads.
	var adsView: UIView? { get }
	
	/// A view controller to present interstial ads.
	var adsViewController: UIViewController? { get }
}

extension UIViewController: AdsPresenter {
	public var adsView: UIView? { nil }
	public var adsViewController: UIViewController? { self }
}

extension UIView: AdsPresenter {
	public var adsView: UIView? { self }
	public var adsViewController: UIViewController? { nil }
}
