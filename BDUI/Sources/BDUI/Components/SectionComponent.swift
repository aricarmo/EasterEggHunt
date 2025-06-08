import SwiftUI

public struct SectionComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        VStack(spacing: 8) {
            if let children = properties.children {
                ForEach(children) { child in
                    ComponentRenderer(component: child)
                }
            }
        }
    }
}
