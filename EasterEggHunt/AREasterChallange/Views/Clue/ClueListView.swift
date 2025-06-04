import SwiftUI
import SwiftData

struct ClueListView: View {
    let clues: [Clue]
    let gameProgress: GameProgress
    let onClueSelected: (Clue) -> Void
    
    var body: some View {
        List {
            ForEach(sortedClues, id: \.id) { clue in
                ClueRowView(clue: clue, isAccessible: isClueAccessible(clue)) {
                    if isClueAccessible(clue) && !clue.isFound {
                        onClueSelected(clue)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var sortedClues: [Clue] {
        clues.sorted { $0.number < $1.number }
    }
    
    private func isClueAccessible(_ clue: Clue) -> Bool {
        return clue.number <= gameProgress.currentClue
    }
}
