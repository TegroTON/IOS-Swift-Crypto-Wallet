import Moya

private let defaultDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        if let date = formatter.date(from: stringValue) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        if let date = formatter.date(from: stringValue) {
            return date
        }
        
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Can't get date"))
    }
    
    return decoder
}()

extension Response {
    
    func decode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = defaultDecoder, failsOnEmptyData: Bool = true) throws -> D {
        return try map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
    }
    
    /// Maps data received from the signal into a Decodable object.
    ///
    /// - parameter atKeyPath: Optional key path at which to parse object.
    /// - parameter using: A `JSONDecoder` instance which is used to decode data to an object.
    func decode<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = defaultDecoder, failsOnEmptyData: Bool = true, atKeyPaths keyPaths: String...) throws -> D {
        let serializeToData: (Any) throws -> Data? = { (jsonObject) in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw MoyaError.jsonMapping(self)
            }
        }
        let jsonData: Data
        keyPathCheck: if keyPaths.count > 0 {
            var extractedJSONObject = try mapJSON(failsOnEmptyData: failsOnEmptyData) as? NSDictionary
            for (index, keyPath) in keyPaths.enumerated() {
                if index == keyPaths.count - 1, let value = extractedJSONObject?.value(forKey: keyPath) as? D {
                    return value
                }
                extractedJSONObject = extractedJSONObject?.value(forKey: keyPath) as? NSDictionary
            }
            guard let jsonObject = extractedJSONObject else {
                if failsOnEmptyData {
                    throw MoyaError.jsonMapping(self)
                } else {
                    jsonData = data
                    break keyPathCheck
                }
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    throw MoyaError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(DecodableWrapper<D>.self, from: wrappedJsonData).value
                } catch let error {
                    throw MoyaError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            if jsonData.count < 1 && !failsOnEmptyData {
                if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONObjectData) {
                    return emptyDecodableValue
                } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONArrayData) {
                    return emptyDecodableValue
                }
            }
            return try decoder.decode(D.self, from: jsonData)
        } catch let error {
            throw MoyaError.objectMapping(error, self)
        }
    }
    
    private struct DecodableWrapper<T: Decodable>: Decodable {
        let value: T
    }
    
}
