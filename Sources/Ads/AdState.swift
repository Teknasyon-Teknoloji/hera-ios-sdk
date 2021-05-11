//
//  AdState.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 7.04.2021.
//

import Foundation

/// It represent an ad state, whether it is shown
/// or dismissed.
enum AdState {
    case showning
    case hidden
    case loading
    case loaded
    case loadingTimedOut
    case unknown
}
