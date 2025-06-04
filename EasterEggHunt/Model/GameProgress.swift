@Model
class GameProgress {
    var currentClue: Int = 1
    var totalFound: Int = 0
    var isSpecialModeUnlocked: Bool = false
    
    init() {}
}
