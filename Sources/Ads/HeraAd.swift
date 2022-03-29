//
//  AdRepresentable.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 7.04.2021.
//

import Foundation

/// Represents any object that can have a state.
protocol HeraAd: AnyObject {
    
    /// Current ad's presentational state.
    var state: AdState { get set }
    
    /// The date represents when the ad is loaded.
    var lastLoadingDate: Date? { get set }
    
    /// The date represents when the ad is last showed.
    var lastShowingDate: Date? { get set }
}
