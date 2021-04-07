//
//  Logger.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 25.01.2021.
//

import Foundation

enum Logger {
    static func log(_ type: Kind = .error,
                    _ args: Any...,
                    function: StaticString = #function,
                    line: Int = #line
    ) {
        if CommandLine.arguments.contains("HERA_DEBUG_ENABLED") {
            print(type.prefix, args.count == 1 ? args[0] : args, "in: \(function) at: \(line)", separator: "")
        }
    }
    
    enum Kind {
        case debug
        case error
        case warning
        case success
    }
}

extension Logger.Kind {
    var prefix: String {
        switch self {
        case .error: return "❌ "
        case .warning: return "⚠️ "
        case .debug: return "⚙️ "
        case .success: return "✅ "
        }
    }
}
