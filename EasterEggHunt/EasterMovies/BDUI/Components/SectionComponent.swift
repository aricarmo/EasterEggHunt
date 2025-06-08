import SwiftUI

struct SectionComponent: View {
    let properties: ComponentProperties
    
    var body: some View {
        VStack(spacing: 8) {
            if let children = properties.children {
                ForEach(children) { child in
                    ComponentRenderer(component: child)
                }
            }
        }
    }
}
