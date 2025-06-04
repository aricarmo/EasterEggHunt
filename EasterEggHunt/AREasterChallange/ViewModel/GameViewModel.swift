import SwiftUI
import SwiftData
import SceneKit

@MainActor
class GameViewModel: ObservableObject {
    @Published var selectedClue: Clue?
    @Published var isInitialized = false
    
    var clueSize: Int
    var modelContext: ModelContext
    
    init(clueSize: Int, modelContext: ModelContext) {
        self.clueSize = clueSize
        self.modelContext = modelContext
    }
    
    // MARK: - Game Setup
    func initializeGame() {
        guard !isInitialized else { return }
        
        let clues = fetchClues()
        let gameProgress = fetchGameProgress()
        
        if clues.isEmpty {
            setupNewGame()
        }
        
        if gameProgress.isEmpty {
            createInitialProgress()
        }
        
        isInitialized = true
    }
    
    func resetGame() {
        let clues = fetchClues()
        let gameProgress = fetchGameProgress()
        
        clues.forEach { modelContext.delete($0) }
        gameProgress.forEach { modelContext.delete($0) }
        
        setupNewGame()
        createInitialProgress()
        
        saveContext()
    }
    
    // MARK: - Clue Management
    func selectClue(_ clue: Clue) {
        selectedClue = clue
    }
    
    func handleClueFound(_ clue: Clue) {
        clue.isFound = true
        
        if let progress = fetchGameProgress().first {
            progress.totalFound += 1
            
            if clue.number < 4 {
                progress.currentClue = clue.number + 1
                unlockNextClue(after: clue.number)
            } else {
                unlockSpecialModes(progress: progress)
            }
        }
        
        selectedClue = nil
        saveContext()
    }
    
    func isClueAccessible(_ clue: Clue) -> Bool {
        if clue.number == 1 {
            return true
        }
        
        let clues = fetchClues()
        if let previousClue = clues.first(where: { $0.number == clue.number - 1 }) {
            return previousClue.isFound
        }
        
        return false
    }
    
    // MARK: - Data Fetching
    func fetchClues() -> [Clue] {
        let descriptor = FetchDescriptor<Clue>(sortBy: [SortDescriptor(\.number)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchGameProgress() -> [GameProgress] {
        let descriptor = FetchDescriptor<GameProgress>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getCurrentGameProgress() -> GameProgress {
        return fetchGameProgress().first ?? GameProgress()
    }
    
    // MARK: - Private Methods
    private func setupNewGame() {
        let newClues = [
            Clue(number: 1, hint: "Já olhou para o céu hoje?", emoji: "🙏", isUnlocked: true, position: SCNVector3(0, 1.5, -2)),
            Clue(number: 2, hint: "É importante saber onde está pisando", emoji: "🐰", isUnlocked: false, position: SCNVector3(0, -0.5, -1.5)),
            Clue(number: 3, hint: "Se der uma rodadinha vai achar uma surpresinha", emoji: "🐔", isUnlocked: false, position: SCNVector3(1.5, 0.5, -2)),
            Clue(number: 4, hint: "Longe longe longe, na esquerda!", emoji: "🎯", isUnlocked: false, position: SCNVector3(-2, 0.8, -2.5))
        ]
        
        newClues.forEach { modelContext.insert($0) }
        saveContext()
    }
    
    private func createInitialProgress() {
        let progress = GameProgress()
        modelContext.insert(progress)
        saveContext()
    }
    
    private func unlockNextClue(after clueNumber: Int) {
        let clues = fetchClues()
        if let nextClue = clues.first(where: { $0.number == clueNumber + 1 }) {
            nextClue.isUnlocked = true
        }
    }
    
    private func unlockSpecialModes(progress: GameProgress) {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            progress.isSpecialModeUnlocked = true
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar contexto: \(error)")
        }
    }
}
