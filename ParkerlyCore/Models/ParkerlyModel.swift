//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public typealias NetworkId = String

public protocol ParkerlyModel: Codable, CustomDebugStringConvertible {

    // MARK: - State

    var id: NetworkId? { get }

    var copyWithoutId: Self { get }
    func copy(withId id: NetworkId?) -> Self

    // MARK: - Encoding

    var encoder: JSONEncoder { get }
    var encoded: Data? { get }
    var encodedString: String? { get }

    // MARK: - Decoding

    static var decoder: JSONDecoder { get }

    static func decode<T: ParkerlyModel>(from json: String) -> T?
    static func decode<T: ParkerlyModel>(from data: Data) -> T?

    static func decodeArray<T: ParkerlyModel>(from data: Data) -> [T]?
    static func decodeArray<T: ParkerlyModel>(from json: String) -> [T]?
}

extension ParkerlyModel {

    // MARK: - Encoding

    public var encoder: JSONEncoder {
        let result = JSONEncoder()
        result.outputFormatting = .prettyPrinted
        return result
    }

    public var encoded: Data? {
        return try? encoder.encode(self)
    }

    public var encodedString: String? {
        guard let data = encoded, let string = String(data: data, encoding: .utf8) else {
            os_log("Couldn't encode %@", String(describing: self))
            return nil
        }
        return string
    }

    // MARK: - Decoding

    public static var decoder: JSONDecoder {
        return JSONDecoder()
    }

    public static func decode<T: ParkerlyModel>(from data: Data) -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            os_log("Caught an error when decoding %@: %@", String(describing: T.self), error.localizedDescription)
            return nil
        }
    }

    public static func decode<T: ParkerlyModel>(from json: String) -> T? {
        guard let data = json.data(using: .utf8) else {
            os_log("Couldn't convert json string \"%@\" to data", json)
            return nil
        }
        return T.decode(from: data)
    }

    public static func decodeArray<T: ParkerlyModel>(from data: Data) -> [T]? {
        do {
            let dict = try decoder.decode([String: T].self, from: data)
            return dict.map { (key, value) -> T in return value.copy(withId: key) }
        } catch {
            os_log("Caught an error when decoding [%@]: %@", String(describing: T.self), error.localizedDescription)
            return nil
        }
    }

    public static func decodeArray<T: ParkerlyModel>(from json: String) -> [T]? {
        guard let data = json.data(using: .utf8) else {
            os_log("Couldn't convert json string \"%@\" to data", json)
            return nil
        }
        return T.decodeArray(from: data)
    }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        return "\(type(of: self))(\(id ?? "nil"))"
    }
}
