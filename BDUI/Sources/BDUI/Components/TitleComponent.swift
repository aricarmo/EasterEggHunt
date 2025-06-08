import SwiftUI

public struct TitleComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        Text(properties.text ?? "")
            .font(.system(size: properties.fontSize ?? 24, weight: fontWeight))
            .foregroundColor(Color(hex: properties.color ?? "#000000"))
            .applyCommonModifiers(properties: properties)
    }
    
    private var fontWeight: Font.Weight {
        switch properties.fontWeight {
        case "bold": return .bold
        case "medium": return .medium
        case "light": return .light
        default: return .regular
        }
    }
}
