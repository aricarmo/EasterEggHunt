import SwiftUI
import Testing
@testable import BDUI

@Suite("ComponentRenderer Integration Tests")
@MainActor struct ComponentRendererIntegrationTests {
    
    @Test("Dever criar o layout de detalhe de filme completo")
    func movieDetailLayout() {
        let posterComponent = UIComponent.mockImage(
            url: "https://example.com/poster.jpg",
            height: 300
        )
        
        let titleComponent = UIComponent.mockText(
            text: "The Office",
            fontSize: 28,
            color: "#000000"
        )
        
        let ratingComponent = UIComponent(
            type: .rating,
            properties: ComponentProperties(
                color: "#FFD700",
                rating: 4.8,
                maxRating: 5.0
            )
        )
        
        let overviewComponent = UIComponent.mockText(
            text: "Era uma vez no The Office",
            fontSize: 16,
            color: "#333333"
        )
        
        let trailerButton = UIComponent.mockButton(
            text: "Ver trailer",
            action: ActionData(
                type: "open_url",
                data: ["url": AnyCodable("https://youtube.com/watch?v=trailer")]
            )
        )
        
        let components = [
            posterComponent,
            titleComponent,
            ratingComponent,
            overviewComponent,
            trailerButton
        ]
        
        let renderers = components.map { ComponentRenderer(component: $0) }
        
        #expect(renderers.count == 5)
        #expect(renderers[0].component.type == .image)
        #expect(renderers[1].component.type == .text)
        #expect(renderers[2].component.type == .rating)
        #expect(renderers[3].component.type == .text)
        #expect(renderers[4].component.type == .button)
        
        #expect(renderers[1].component.properties.text == "The Office")
        #expect(renderers[2].component.properties.rating == 4.8)
        #expect(renderers[4].component.properties.action?.type == "open_url")
    }
}

extension UIComponent {
    static func mockText(
        text: String = "Mock Text",
        fontSize: Double = 16,
        color: String = "#000000"
    ) -> UIComponent {
        return UIComponent(
            type: .text,
            properties: ComponentProperties(
                text: text,
                fontSize: fontSize,
                color: color
            )
        )
    }
    
    static func mockButton(
        text: String = "Mock Button",
        action: ActionData? = nil
    ) -> UIComponent {
        return UIComponent(
            type: .button,
            properties: ComponentProperties(
                text: text,
                fontSize: 16,
                fontWeight: "bold",
                color: "#FFFFFF",
                backgroundColor: "#007AFF",
                action: action
            )
        )
    }
    
    static func mockImage(
        url: String = "https://example.com/image.jpg",
        height: Double = 200
    ) -> UIComponent {
        return UIComponent(
            type: .image,
            properties: ComponentProperties(
                imageUrl: url,
                cornerRadius: 8, height: height
            )
        )
    }
    
    static func mockSection(
        children: [UIComponent],
        spacing: Double = 8
    ) -> UIComponent {
        return UIComponent(
            type: .section,
            properties: ComponentProperties(
                children: children
            )
        )
    }
}
