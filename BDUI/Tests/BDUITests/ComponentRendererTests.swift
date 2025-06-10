import Testing
import SwiftUI
@testable import BDUI

@Suite("ComponentRenderer Tests")
@MainActor
struct ComponentRendererSimpleTests {
    
    @MainActor @Test("Deve inicializar corretamente com um componente")
    func initialization() {
        let component = UIComponent.mockText(text: "Test")
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.type == .text)
        #expect(renderer.component.properties.text == "Test")
    }
    
    
    @Test("Deve preservar as propriedades do componente")
    func componentProperties() {
        let properties = ComponentProperties(text: "That's funny! hahahaha", imageUrl: nil, fontSize: 24, fontWeight: "bold", color: "#FF0000", backgroundColor: "#00FF00", padding: .simple(20), cornerRadius: 10, rating: nil, maxRating: nil, height: nil, width: nil, children: nil, action: nil, isEnabled: true)
        let component = UIComponent(type: .text, properties: properties)
        
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.properties.text == "That's funny! hahahaha")
        #expect(renderer.component.properties.fontSize == 24)
        #expect(renderer.component.properties.fontWeight == "bold")
        #expect(renderer.component.properties.color == "#FF0000")
        #expect(renderer.component.properties.backgroundColor == "#00FF00")
        #expect(renderer.component.properties.cornerRadius == 10)
        
        switch renderer.component.properties.padding {
        case .simple(let value):
            #expect(value == 20)
        default:
            Issue.record("Esperado um padding simples")
        }
    }
    
    @Test("Deve lidar com um padding complexo")
    func complexPadding() {
        let edgeInsets = EdgeInsetsValue(top: 10, leading: 15, bottom: 20, trailing: 25)
        let properties = ComponentProperties(text: "Helloooo", fontSize: 24, fontWeight: "bold", color: "#FF0000", backgroundColor: "#00FF00", padding: .complex(edgeInsets), cornerRadius: 10, isEnabled: true)
        let component = UIComponent(type: .text, properties: properties)
        let renderer = ComponentRenderer(component: component)
        
        switch renderer.component.properties.padding {
        case .complex(let extractedEdgeInsets):
            #expect(extractedEdgeInsets.top == 10)
        
            #expect(extractedEdgeInsets.leading == 15)
            #expect(extractedEdgeInsets.bottom == 20)
            #expect(extractedEdgeInsets.trailing == 25)
        default:
            Issue.record("É esperado um complex")
        }
    }
    
    @Test("Deve lidar com um Action Button")
    func buttonWithAction() {
        let actionData = ActionData(
            type: "open_url",
            data: ["url": AnyCodable("https://apple.com")]
        )
        let properties = ComponentProperties(text: "Click me", action: actionData, isEnabled: true)
        let component = UIComponent(type: .button, properties: properties)
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.properties.action?.type == "open_url")
        #expect(renderer.component.properties.action?.data?["url"]?.value as? String == "https://apple.com")
    }
    
    @Test("Deve lidar com uma section com section children")
    func sectionWithChildren() {
        let child1 = UIComponent.mockText(text: "Child 1")
        let child2 = UIComponent.mockText(text: "Child 2")
        let properties = ComponentProperties(
            children: [child1, child2]
        )
        let component = UIComponent(type: .section, properties: properties)
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.properties.children?.count == 2)
        #expect(renderer.component.properties.children?[0].properties.text == "Child 1")
        #expect(renderer.component.properties.children?[1].properties.text == "Child 2")
    }
    
    @Test("Deve lidar com texto vazio")
    func emptyText() {
        let component = UIComponent.mockText(text: "")
        let renderer = ComponentRenderer(component: component)

        #expect(renderer.component.properties.text == "")
    }
    
    @Test("Deve lidar com propriedades nulas")
    func nilProperties() {
        let properties = ComponentProperties()
        let component = UIComponent(type: .text, properties: properties)
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.properties.text == nil)
        #expect(renderer.component.properties.fontSize == nil)
        #expect(renderer.component.properties.color == nil)
    }
    
    @Test("Testando texto looongo")
    func veryLongText() {
        let longText = String(repeating: "Lorem ipsum dolor sit amet. ", count: 50)
        let component = UIComponent.mockText(text: longText)
        let renderer = ComponentRenderer(component: component)
        
        #expect(renderer.component.properties.text == longText)
        #expect(renderer.component.properties.text?.count == longText.count)
    }
    
    @Test("Tamanho zerado")
    func zeroDimensions() {
        let properties = ComponentProperties(
            fontSize: 0,
            padding: .simple(0),
            height: 0,
            width: 0
        )
        let component = UIComponent(type: .text, properties: properties)
        let renderer = ComponentRenderer(component: component)
    
        #expect(renderer.component.properties.width == 0)
        #expect(renderer.component.properties.height == 0)
        #expect(renderer.component.properties.fontSize == 0)
    }
    
    @Test("Deve lidar com numeros negativos")
    func negativeValues() {
        let properties = ComponentProperties(
            fontSize: -10,
            padding: .simple(-5)
        )
        let component = UIComponent(type: .text, properties: properties)
        let renderer = ComponentRenderer(component: component)
        #expect(renderer.component.properties.fontSize == -10)
        
        switch renderer.component.properties.padding {
        case .simple(let value):
            #expect(value == -5)
        default:
            Issue.record("Expero um single padding")
        }
    }
}
