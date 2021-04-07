//
//  String+GDPR Countries.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 28.01.2021.
//

import Foundation

internal extension String {
    private var gdprCountries: [String] {
        [
            "BE",
            "BG",
            "CZ",
            "DK",
            "DE",
            "EE",
            "IE",
            "EL",
            "ES",
            "FR",
            "HR",
            "IT",
            "CY",
            "LV",
            "LT",
            "LU",
            "HU",
            "MT",
            "NL",
            "AT",
            "PL",
            "PT",
            "RO",
            "SI",
            "SK",
            "FI",
            "SE"
        ]
    }
    
    var isSubjectToGDBR: Bool {
        gdprCountries.contains(self)
    }
}
