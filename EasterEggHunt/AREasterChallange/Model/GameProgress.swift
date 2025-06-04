import SwiftData

@Model
class GameProgress: @unchecked Sendable {
    var currentClue: Int = 1
    var totalFound: Int = 0
    var isSpecialModeUnlocked: Bool = false
    
    init() {}
}
