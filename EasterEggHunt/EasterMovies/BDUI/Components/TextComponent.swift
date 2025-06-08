import SwiftUI

struct TextComponent: View {
    let properties: ComponentProperties
    
    var body: some View {
        Text(properties.text ?? "")
            .font(.system(size: properties.fontSize ?? 16))
            .foregroundColor(Color(hex: properties.color ?? "#000000"))
            .multilineTextAlignment(.leading)
            .applyCommonModifiers(properties: properties)
    }
}
