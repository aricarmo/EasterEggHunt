import SwiftUI

public struct SpacerComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        Spacer()
            .frame(height: properties.height ?? 10)
    }
}
