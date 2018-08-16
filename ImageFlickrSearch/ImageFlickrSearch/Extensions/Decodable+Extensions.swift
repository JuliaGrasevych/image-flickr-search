//
//  Decodable+Extensions.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

extension Decodable {
    // MARK: - Class methods
    static func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    }
    static func fill<T: Decodable>(withDictionary dictionary: [String: Any]) -> T? {
        do {
            let json = try dictionary.jsonRepresentation()
            let item: T = try T.decode(data: json)
            return item
        } catch let exception {
            print(exception)
            return nil
        }
    }
}
