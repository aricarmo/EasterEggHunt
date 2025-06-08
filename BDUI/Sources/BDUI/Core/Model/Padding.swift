import SwiftUI

public struct EdgeInsetsValue: Codable, Sendable {
    let top: Double
    let leading: Double
    let bottom: Double
    let trailing: Double
    
    init(top: Double = 0, leading: Double = 0, bottom: Double = 0, trailing: Double = 0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    init(all: Double) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
    
    init(horizontal: Double = 0, vertical: Double = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

public enum PaddingValue: Codable, Sendable {
    case simple(Double)
    case complex(EdgeInsetsValue)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let double = try? container.decode(Double.self) {
            self = .simple(double)
            return
        }
        
        if let edgeInsets = try? container.decode(EdgeInsetsValue.self) {
            self = .complex(edgeInsets)
            return
        }
        
        throw DecodingError.typeMismatch(
            PaddingValue.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: ""
            )
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .simple(let double):
            try container.encode(double)
        case .complex(let edgeInsets):
            try container.encode(edgeInsets)
        }
    }
}

