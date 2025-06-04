import SwiftUI
import SwiftData
import ARKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var clues: [Clue]
    @Query var gameProgress: [GameProgress]
    @State var showARView: Bool = false
    @State var selectedClue: Clue?
    
    var body: some View {
        NavigationView {
            VStack {
                if clues.isEmpty {
                    
                } else {
                    ClueListView(clues: clues, gameProgress: currentGameProgress) { clue in
                        selectedClue = clue
                    }
                }
                
                Spacer()
                
                if currentGameProgress.isSpecialModeUnlocked {
                    // specialModelButton
                }
            }
            .navigationTitle("🐰 Caça aos Ovos")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            setupGameIfNeeded()
        }
        .sheet(item: $selectedClue) { clue in
            ARCameraView(targetClue: clue) { foundClue in
                handleClueFound(foundClue)
                selectedClue = nil
            }
        }
        
    }
    
    var currentGameProgress: GameProgress {
        gameProgress.first ?? GameProgress()
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("🥚 Encontre as pistas escondidas!")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            ProgressView(
                value: Double(currentGameProgress.totalFound),
                total: 4.0
            )
            .tint(.orange)
            
            Text("\(currentGameProgress.totalFound)/4 pistas encontradas")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private var specialModeButton: some View {
        Button("🐾 Seguir as Pegadas do Coelho") {
            // TODO: Implementar modo especial
        }
        .buttonStyle(.borderedProminent)
        .tint(.pink)
        .controlSize(.large)
        .padding()
    }
}
