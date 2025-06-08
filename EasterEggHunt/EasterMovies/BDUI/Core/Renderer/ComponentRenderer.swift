import SwiftUI

struct ComponentRenderer: View {
    let component: UIComponent
    @EnvironmentObject var actionManager: ActionManager
    
    var body: some View {
        content.applyCommonModifiers(properties: component.properties)
    }
    
    @ViewBuilder
    private var content: some View {
        switch component.type {
        case .image:
            ImageComponent(properties: component.properties)
        case .text:
            TextComponent(properties: component.properties)
        case .title:
            TitleComponent(properties: component.properties)
        case .subtitle:
            SubtitleComponent(properties: component.properties)
        case .spacer:
            SpacerComponent(properties: component.properties)
        case .divider:
            DividerComponent()
        case .button:
            ButtonComponent(properties: component.properties)
                .environmentObject(actionManager)
        case .rating:
            RatingComponent(properties: component.properties)
        case .section:
            SectionComponent(properties: component.properties)
                .environmentObject(actionManager)
        case .chip:
            ChipComponent(properties: component.properties)
            
        default:
            EmptyView()
        }
        
    }
}
