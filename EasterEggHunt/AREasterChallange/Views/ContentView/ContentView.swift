import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var clues: [Clue]
    @Query private var gameProgress: [GameProgress]
    
    var body: some View {
        ContentListView(
            clues: clues,
            gameProgress: gameProgress
        )
        .environmentObject(GameViewModel(clueSize: clues.count,
                                         modelContext: modelContext))
    }
}

struct ContentListView: View {
    let clues: [Clue]
    let gameProgress: [GameProgress]
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(gameProgress: currentGameProgress, clues: clues)
                
                if clues.isEmpty && !gameViewModel.isInitialized {
                    SetupGameView {
                        gameViewModel.resetGame()
                    }
                } else {
                    ClueListView(
                        clues: clues,
                        gameProgress: currentGameProgress,
                        onClueSelected: gameViewModel.selectClue
                    )
                }
                
                Spacer()
                
                GameActionsView(gameProgress: currentGameProgress)
            }
            .navigationTitle("Caça aos Ovos 🐰")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            gameViewModel.initializeGame()
        }
        .sheet(item: $gameViewModel.selectedClue) { clue in
            ARCameraView(
                targetClue: clue,
                onClueFound: gameViewModel.handleClueFound
            )
        }
    }
    
    private var currentGameProgress: GameProgress {
        gameProgress.first ?? GameProgress()
    }
}
