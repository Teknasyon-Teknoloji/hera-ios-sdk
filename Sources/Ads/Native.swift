//
//  Native.swift
//  HeraSDK
//
//  Created by Ali Ammar Hilal on 19.08.2021.
//

import Foundation

/// A type representing the banner ad.
final class Native: HeraAd {
    var state: AdState = .hidden
    var lastLoadingDate: Date?
    var lastShowingDate: Date?
}
