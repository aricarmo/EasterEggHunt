import SwiftUI

struct SpacerComponent: View {
    let properties: ComponentProperties
    
    var body: some View {
        Spacer()
            .frame(height: properties.height ?? 10)
    }
}
