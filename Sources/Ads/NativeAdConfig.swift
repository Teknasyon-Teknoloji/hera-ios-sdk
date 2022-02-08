//
//  NativeAdConfig.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 6.09.2021.
//

import UIKit

public class NativeAdConfig: Hashable {
    public let nibName: String
    public let viewClass: HeraNativeAdRenderer.Type
    public let size: CGSize
    public let indexPath: IndexPath?
    
    internal var adView: UIView?
    
    public init(
        nibName: String,
        viewClass: HeraNativeAdRenderer.Type = DefaultNativeRenderer.self,
        size: CGSize,
        indexPath: IndexPath? = nil
    ) {
        self.nibName = nibName
        self.viewClass = viewClass
        self.size = size
        self.indexPath = indexPath
        DefaultNativeRenderer.nibName = nibName
    }
    
    public static func == (lhs: NativeAdConfig, rhs: NativeAdConfig) -> Bool {
        lhs.nibName == rhs.nibName && lhs.viewClass == rhs.viewClass
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(nibName)
        hasher.combine(String(describing: viewClass))
    }
    
    public func retrieveAdView() -> UIView? {
        adView
    }
}
