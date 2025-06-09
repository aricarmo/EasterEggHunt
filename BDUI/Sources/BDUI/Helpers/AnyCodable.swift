import Foundation

public struct AnyCodable: Codable, Sendable {
    private enum CodableValue: Codable, Sendable {
        case bool(Bool)
        case int(Int)
        case double(Double)
        case string(String)
        case null
        
        var anyValue: Any? {
            switch self {
            case .bool(let value): return value
            case .int(let value): return value
            case .double(let value): return value
            case .string(let value): return value
            case .null: return nil
            }
        }
    }
    
    private let codableValue: CodableValue
    
    public var value: Any? {
        codableValue.anyValue
    }
    
    public init<T>(_ value: T?) {
        if let value = value {
            switch value {
            case let bool as Bool:
                self.codableValue = .bool(bool)
            case let int as Int:
                self.codableValue = .int(int)
            case let double as Double:
                self.codableValue = .double(double)
            case let string as String:
                self.codableValue = .string(string)
            default:
                self.codableValue = .null
            }
        } else {
            self.codableValue = .null
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            codableValue = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            codableValue = .int(int)
        } else if let double = try? container.decode(Double.self) {
            codableValue = .double(double)
        } else if let string = try? container.decode(String.self) {
            codableValue = .string(string)
        } else {
            codableValue = .null
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch codableValue {
        case .bool(let bool):
            try container.encode(bool)
        case .int(let int):
            try container.encode(int)
        case .double(let double):
            try container.encode(double)
        case .string(let string):
            try container.encode(string)
        case .null:
            try container.encodeNil()
        }
    }
}
