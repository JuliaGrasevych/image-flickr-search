//
//  Codable+Extensions.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

protocol DateDecodingStrategyProvider {
    static func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy
}

extension Decodable {
    // MARK: - Class methods
    static func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        if let provider = T.self as? DateDecodingStrategyProvider.Type {
            decoder.dateDecodingStrategy = provider.dateDecodingStrategy()
        }
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

extension Encodable {
    var jsonDictionary: [String: AnyObject]? {
        let coder = JSONEncoder()
        coder.dateEncodingStrategy = .secondsSince1970
        guard let jsonData = try? coder.encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)) as? [String: AnyObject]
    }
    var jsonArray: [AnyObject]? {
        let coder = JSONEncoder()
        coder.dateEncodingStrategy = .secondsSince1970
        guard let jsonData = try? coder.encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)) as? [AnyObject]
    }
}
