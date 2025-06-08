import SwiftUI

extension View {
    func applyCommonModifiers(properties: ComponentProperties) -> some View {
        self.applyPadding(properties.padding)
            .background(
                properties.backgroundColor.map { Color(hex: $0) } ?? Color.clear
            )
            .cornerRadius(properties.cornerRadius ?? 0)
            .frame(
                width: properties.width,
                height: properties.height
            )
    }
    
    @ViewBuilder
    func applyPadding(_ paddingValue: PaddingValue?) -> some View {
        switch paddingValue {
        case .simple(let value):
            self.padding(value)
        case .complex(let edgeInsets):
            self.padding(.top, edgeInsets.top)
            self.padding(.leading, edgeInsets.leading)
            self.padding(.bottom, edgeInsets.bottom)
            self.padding(.trailing, edgeInsets.trailing)
        case .none:
            self
        }
    }
}
