//
//  JSONEncoder + Ext.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 25.01.2021.
//

import Foundation

extension JSONEncoder {
    private struct EncodableWrapper: Encodable {
        let wrapped: Encodable

        func encode(to encoder: Encoder) throws {
            try self.wrapped.encode(to: encoder)
        }
    }
    
    func encode<Key: Encodable>(_ dictionary: [Key: Encodable]) throws -> Data {
        let wrappedDict = dictionary.mapValues(EncodableWrapper.init(wrapped:))
        return try self.encode(wrappedDict)
    }
}
