import SwiftUI

public struct BDUI {
    public static let version = "1.0.0"
    
    public static func initialize() { }
}

public struct BDUIView: View {
    let components: [UIComponent]
    let spacing: CGFloat
    let actionManager: ActionManager
    
    public init(components: [UIComponent], spacing: CGFloat = 0, actionManager: ActionManager) {
        self.components = components
        self.spacing = spacing
        self.actionManager = actionManager
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: spacing) {
                ForEach(components) { component in
                    ComponentRenderer(component: component)
                        .environmentObject(actionManager)
                }
            }
        }
    }
}
