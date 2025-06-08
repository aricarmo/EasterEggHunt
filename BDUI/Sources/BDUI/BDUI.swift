import SwiftUI

public struct BDUI {
    public static let version = "1.0.0"
    
    public static func initialize() { }
}

// MARK: - Main BDUI View
/// Main view for rendering a list of BDUI components
public struct BDUIView: View {
    let components: [UIComponent]
    let spacing: CGFloat
    
    public init(components: [UIComponent], spacing: CGFloat = 0) {
        self.components = components
        self.spacing = spacing
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: spacing) {
                ForEach(components) { component in
                    ComponentRenderer(component: component)
                }
            }
        }
    }
}

// MARK: - Public Extensions
public extension View {
    /// Apply BDUI styling to any view
    func bduiStyle() -> some View {
        self
            .font(.system(.body, design: .default))
            .foregroundColor(.primary)
    }
}
