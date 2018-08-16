//
//  Dictionary+Json.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

enum JsonConvertingError: Error {
    case notValidJsonObject
}

extension Dictionary {
    func jsonRepresentation() throws -> Data {
        let convertedDict = self.mapValues { (item) -> Any in
            if let dateItem = item as? Date {
                // TODO: use unique format
                return dateItem.timeIntervalSince1970
            }
            return item
        }
        guard JSONSerialization.isValidJSONObject(convertedDict) else {
            throw JsonConvertingError.notValidJsonObject
        }
        return try JSONSerialization.data(withJSONObject: convertedDict, options: .prettyPrinted)
    }
}
