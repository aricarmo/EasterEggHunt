import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var clues: [Clue]
    @Query private var gameProgress: [GameProgress]
    
    var body: some View {
        ContentListView(
            clues: clues,
            gameProgress: gameProgress,
            modelContext: modelContext
        )
    }
}

struct ContentListView: View {
    let clues: [Clue]
    let gameProgress: [GameProgress]
    @StateObject private var gameViewModel: GameViewModel
    
    init(clues: [Clue], gameProgress: [GameProgress], modelContext: ModelContext) {
        self.clues = clues
        self.gameProgress = gameProgress
        self._gameViewModel = StateObject(
            wrappedValue: GameViewModel(
                clueSize: clues.count,
                modelContext: modelContext
            )
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(gameProgress: currentGameProgress)
                
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
            .navigationTitle("🐰 Caça aos Ovos")
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

// MARK: - Subviews
struct HeaderView: View {
    let gameProgress: GameProgress
    
    var body: some View {
        VStack(spacing: 8) {
            Text("🥚 Encontre as pistas escondidas!")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            ProgressView(
                value: Double(gameProgress.totalFound),
                total: 4.0
            )
            .tint(.orange)
            
            Text("\(gameProgress.totalFound)/4 pistas encontradas")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct SetupGameView: View {
    let onSetup: () -> Void
    
    var body: some View {
        Button("🎯 Iniciar Caça aos Ovos") {
            onSetup()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

struct GameActionsView: View {
    let gameProgress: GameProgress
    
    var body: some View {
        VStack(spacing: 12) {
            if gameProgress.isSpecialModeUnlocked {
                NavigationLink(destination: MovieListView()) {
                    Text("Filmes de Páscoa 🎬")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .controlSize(.large)
            }
        }
        .padding()
    }
}

// MARK: - GameViewModel Extension
extension GameViewModel {
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
}
