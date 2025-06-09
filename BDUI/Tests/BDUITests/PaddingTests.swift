import Testing
import Foundation
@testable import BDUI

@Suite("EdgeInsets Tests")
struct EdgeInsetsTests {
    @Test("A inicialização padrão tem que estar zerada")
    func defaultInitialization () {
        let edgeInsets = EdgeInsetsValue()
        
        #expect(edgeInsets.top == 0.0)
        #expect(edgeInsets.leading == 0.0)
        #expect(edgeInsets.bottom == 0.0)
        #expect(edgeInsets.trailing == 0.0)
    }
    
    @Test("A inicialização com valores deve ser diferente da padrão")
    func customInitialization () {
        let edgeInsets: EdgeInsetsValue = EdgeInsetsValue(top: 10, leading: 20, bottom: 30, trailing: 40)
        
        #expect(edgeInsets.top == 10.0)
        #expect(edgeInsets.leading == 20.0)
        #expect(edgeInsets.bottom == 30.0)
        #expect(edgeInsets.trailing == 40.0)
    }
    
    @Test("Horizontal/Vertical inicialização deve setar os valores corretamente")
    func horizontalVerticalInitialization() {
        let horizontal = 20.0
        let vertical = 30.0
        let edgeInsets = EdgeInsetsValue(horizontal: horizontal, vertical: vertical)
        
        #expect(edgeInsets.top == vertical)
        #expect(edgeInsets.leading == horizontal)
        #expect(edgeInsets.bottom == vertical)
        #expect(edgeInsets.trailing == horizontal)
    }
    
    @Test("Encoding e decoding deve preservar os valores")
    func encodingDecoding() throws {
        let originalEdgeInsets = EdgeInsetsValue(top: 10, leading: 15, bottom: 20, trailing: 25)
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalEdgeInsets)
        let decoder = JSONDecoder()
        let decodedEdgeInsets = try decoder.decode(EdgeInsetsValue.self, from: data)

        #expect(decodedEdgeInsets.top == originalEdgeInsets.top)
        #expect(decodedEdgeInsets.leading == originalEdgeInsets.leading)
        #expect(decodedEdgeInsets.bottom == originalEdgeInsets.bottom)
        #expect(decodedEdgeInsets.trailing == originalEdgeInsets.trailing)
    }
    
    @Test("Os valores negativos devem ser setados corretamente",
          arguments: [
            (-10.0, -5.0, -15.0, -20.0),
            (-1.5, -2.5, -3.5, -4.5),
            (0.0, -10.0, 5.0, -15.0)
          ])
    func negativeValues(top: Double, leading: Double, bottom: Double, trailing: Double) {
    let edgeInsets = EdgeInsetsValue(top: top, leading: leading, bottom: bottom, trailing: trailing)

    #expect(edgeInsets.top == top)
    #expect(edgeInsets.leading == leading)
    #expect(edgeInsets.bottom == bottom)
    #expect(edgeInsets.trailing == trailing)
    }
}


