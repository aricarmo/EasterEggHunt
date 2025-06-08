import SwiftUI

struct ChipComponent: View {
    let properties: ComponentProperties
    
    var body: some View {
        Text(properties.text ?? "")
            .font(.system(size: properties.fontSize ?? 14, weight: fontWeight))
            .foregroundColor(Color(hex: properties.color ?? "#FFFFFF"))
            .background(Color(hex: properties.backgroundColor ?? "#007AFF"))
            .cornerRadius(properties.cornerRadius ?? 16)
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
