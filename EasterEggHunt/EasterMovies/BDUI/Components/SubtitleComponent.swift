import SwiftUI

struct SubtitleComponent: View {
    let properties: ComponentProperties
    
    var body: some View {
        Text(properties.text ?? "")
            .font(.system(size: properties.fontSize ?? 18, weight: fontWeight))
            .foregroundColor(Color(hex: properties.color ?? "#666666"))
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
