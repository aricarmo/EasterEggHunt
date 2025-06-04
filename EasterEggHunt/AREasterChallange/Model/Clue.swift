import SwiftUI
import SwiftData
import ARKit

@Model
class Clue {
    var id: UUID
    var number: Int
    var hint: String
    var emoji: String
    var isFound: Bool
    var isUnlocked: Bool
    var positionX: Float
    var positionY: Float
    var positionZ: Float
    
    init(
        number: Int,
        hint: String,
        emoji: String,
        isFound: Bool = false,
        isUnlocked: Bool = false,
        position: SCNVector3 = SCNVector3(0, 0, 0)
    ) {
        self.id = UUID()
        self.number = number
        self.hint = hint
        self.emoji = emoji
        self.isFound = isFound
        self.isUnlocked = isUnlocked
        self.positionX = position.x
        self.positionY = position.y
        self.positionZ = position.z
    }
    
    var SCNCoordinates: SCNVector3 {
        get { SCNVector3(positionX, positionY, positionZ) }
        set {
            positionX = newValue.x
            positionY = newValue.y
            positionZ = newValue.z
        }
    }
}
