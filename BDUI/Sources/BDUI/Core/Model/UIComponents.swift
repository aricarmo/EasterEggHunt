import Foundation

public struct UIComponent: Codable, Identifiable, Sendable {
    public let id = UUID()
    public let type: ComponentType
    public let properties: ComponentProperties
    
    public enum CodingKeys: String, CodingKey {
        case type
        case properties
    }
}

public enum ComponentType: String, Codable, Sendable {
    case text
    case title
    case subtitle
    case image
    case rating
    case spacer
    case divider
    case chip
    case section
    case button
    case label
}

public struct ComponentProperties: Codable, Sendable {
    public let text: String?
    public let imageUrl: String?
    public let fontSize: Double?
    public let fontWeight: String?
    public let color: String?
    public let backgroundColor: String?
    public let padding: PaddingValue?
    public let cornerRadius: Double?
    public let rating: Double?
    public let maxRating: Double?
    public let height: CGFloat?
    public let width: CGFloat?
    public let children: [UIComponent]?
    public let action: ActionData?
    public let isEnabled: Bool?
    
    public enum CodingKeys: String, CodingKey {
        case text, imageUrl, fontSize, fontWeight, color, backgroundColor
        case padding, cornerRadius, rating, maxRating, children
        case width, height
        case action, isEnabled
    }
}

public struct ActionData: Codable, Sendable {
    let type: String
    let data: [String: AnyCodable]?
}
