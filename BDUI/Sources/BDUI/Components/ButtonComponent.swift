import SwiftUI

public struct ButtonComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        Button(action: {
            ActionManager().execute(properties.action)
        }) {
            Text(properties.text ?? "Button")
                .font(.system(size: properties.fontSize ?? 16, weight: fontWeight))
                .foregroundColor(Color(hex: properties.color ?? "#FFFFFF"))
                .frame(height: properties.height ?? 44)
                .frame(maxWidth: .infinity)
                .background(Color(hex: properties.backgroundColor ?? "#007AFF"))
                .cornerRadius(properties.cornerRadius ?? 8)
        }
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
    
    private func handleAction(_ action: ActionData?) {
        guard let action = action else { return }
        
        switch action.type {
        case "open_url":
            print("")
        default:
            print("Ação: \(action)")
        }
    }
}
