//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public protocol ParkerlyModel: Codable {

    var encoder: JSONEncoder { get }

    static var decoder: JSONDecoder { get }

    var asJsonData: Data? { get }

    var encoded: String? { get }

    static func decode<T: Decodable>(from json: String) -> T?
}

extension ParkerlyModel {

    public var encoder: JSONEncoder {
        let result = JSONEncoder()
        result.outputFormatting = .prettyPrinted
        return result
    }

    public static var decoder: JSONDecoder {
        return JSONDecoder()
    }

    public var asJsonData: Data? {
        return try? encoder.encode(self)
    }

    public var encoded: String? {
        guard let data = asJsonData, let string = String(data: data, encoding: .utf8) else {
            os_log("Couldn't encode %s", String(describing: self))
            return nil
        }
        return string
    }

    public static func decode<T: Decodable>(from json: String) -> T? {
        guard let data = json.data(using: .utf8) else {
            os_log("Couldn't convert json string \"%s\" to data", json)
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }
}
