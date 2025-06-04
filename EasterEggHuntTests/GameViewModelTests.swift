import Testing
import Foundation
import SwiftData

@testable import EasterEggHunt

@Suite("Game Initialization Tests")
struct GameInitializationTests {
    
    private func createInMemoryModelContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Clue.self, GameProgress.self, configurations: config)
    }
    
    @MainActor private func createGameViewModel() throws -> GameViewModel {
        let container = try createInMemoryModelContainer()
        return GameViewModel(clueSize: 0, modelContext: container.mainContext)
    }
    
    @MainActor @Test("Deve inicializar o jogo quando ainda não está inicializado")
    func testShouldInitializeGameWhenNotInitialized() throws {
        // Given
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        #expect(gameViewModel.isInitialized == false)
        #expect(gameViewModel.fetchClues().isEmpty)
        #expect(gameViewModel.fetchGameProgress().isEmpty)
        
        gameViewModel.initializeGame()
        
        #expect(gameViewModel.isInitialized == true)
        
        let clues = gameViewModel.fetchClues()
        let gameProgress = gameViewModel.fetchGameProgress()
        
        #expect(gameProgress.count == 1)
        #expect(clues.count > 0)
        #expect(clues[0].isUnlocked == true)
    }
    
    @MainActor @Test("Não deve reiniciar o jogo quando o jogo ja está inicializado")
    func testShouldNotReinitializeWhenAlreadyInitialized() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        #expect(gameViewModel.isInitialized == true)
        
        let initialCluesCount = gameViewModel.fetchClues().count
        let initialProgressCount = gameViewModel.fetchGameProgress().count
        
        gameViewModel.initializeGame()
        
        #expect(gameViewModel.isInitialized == true)
        #expect(gameViewModel.fetchClues().count == initialCluesCount)
        #expect(gameViewModel.fetchGameProgress().count == initialProgressCount)
    }
    
    @MainActor @Test("Deve criar o progresso quando está vazio")
    func testShouldCreateProgressWhenEmpty() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        #expect(gameViewModel.fetchGameProgress().isEmpty)
        
        gameViewModel.initializeGame()
        
        let gameProgress = gameViewModel.fetchGameProgress()
        #expect(gameProgress.count == 1)
        
        let progress = gameProgress.first!
        #expect(progress.totalFound == 0)
        #expect(progress.currentClue == 1)
        #expect(progress.isSpecialModeUnlocked == false)
    }
}

@Suite("Handle Clue Found")
struct HandleClueFoundTests {
    
    @MainActor @Test("Deve marcar a pista como encontrado")
    func testShouldMarkClueAsFound() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        let clues = gameViewModel.fetchClues()
        let firstClue = clues.first { $0.number == 1 }!
        
        #expect(firstClue.isFound == false)
        
        gameViewModel.handleClueFound(firstClue)
        
        #expect(firstClue.isFound == true)
    }
    
    @MainActor @Test("Deve incrementar o total encontrado")
    func testShouldIncrementTotalFoundCount() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        let clues = gameViewModel.fetchClues()
        let firstClue = clues.first { $0.number == 1 }!
        let initialProgress = gameViewModel.fetchGameProgress().first!
        
        #expect(initialProgress.totalFound == 0)
        
        gameViewModel.handleClueFound(firstClue)
        
        let updatedProgress = gameViewModel.fetchGameProgress().first!
        #expect(updatedProgress.totalFound == 1)
    }
    
    @MainActor @Test("Deve liberar a proxima pista quando não é a ultima")
    func testShouldUnlockNextClueWhenNotLast() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        let clues = gameViewModel.fetchClues()
        let firstClue = clues.first { $0.number == 1 }!
        let secondClue = clues.first { $0.number == 2 }!
        
        #expect(firstClue.isUnlocked == true)
        #expect(secondClue.isUnlocked == false)
        
        gameViewModel.handleClueFound(firstClue)
        
        #expect(secondClue.isUnlocked == true)
    }
    
    @MainActor @Test("Deve concluir a pista ao encontrar a última pista")
    func testShouldClearSelectedClue() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        let clues = gameViewModel.fetchClues()
        let firstClue = clues.first { $0.number == 1 }!
        
        gameViewModel.selectClue(firstClue)
        #expect(gameViewModel.selectedClue != nil)
        #expect(gameViewModel.selectedClue?.number == 1)

        gameViewModel.handleClueFound(firstClue)
        #expect(gameViewModel.selectedClue == nil)
    }
    
    @MainActor @Test("Deve salvar o contexto após encontrar a pista")
    func testShouldSaveContextAfterFound() throws {
        let container = try createInMemoryModelContainer()
        let gameViewModel = GameViewModel(clueSize: 0, modelContext: container.mainContext)
        
        gameViewModel.initializeGame()
        let clues = gameViewModel.fetchClues()
        let firstClue = clues.first { $0.number == 1 }!
        
        gameViewModel.handleClueFound(firstClue)
        
        let updatedClues = gameViewModel.fetchClues()
        let updatedFirstClue = updatedClues.first { $0.number == 1 }!
        let updatedProgress = gameViewModel.fetchGameProgress().first!
        
        #expect(updatedFirstClue.isFound == true)
        #expect(updatedProgress.totalFound == 1)
    }
    
}

@MainActor
private func createInMemoryModelContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try ModelContainer(for: Clue.self, GameProgress.self, configurations: config)
}
