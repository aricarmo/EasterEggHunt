//
//  ContentViewExt.swift
//  EasterEggHunt
//
//  Created by Arilson Simplicio on 03/06/25.
//

extension ContentView {
    func setupGameIfNeeded() {
        if clues.isEmpty {
            setupGame()
        }
        
        if gameProgress.isEmpty {
            let progress = GameProgress()
            modelContext.insert(progress)
        }
    }
    
    func setupGame() {
        clues.forEach { modelContext.delete($0)}
        gameProgress.forEach { modelContext.delete($0)}
        
        let newClues = [
            Clue(number: 1, hint: "Já olhou para o céu hoje?", emoji: "🙏", isUnlocked: true ),
            Clue(number: 2, hint: "É importante saber onde está pisando", emoji: "🐰"),
            Clue(number: 3, hint: "Se der uma rodadinha vai achar uma surpresinha", emoji: "🐔" ),
            Clue(number: 4, hint: "Longe longe longe, na esquerda!", emoji: "🎯")
        ]
        
        newClues.forEach { modelContext.insert($0) }
        
        let progress = GameProgress()
        modelContext.insert(progress)
        
        try? modelContext.save()
    }
    
    func handleClueFound(_ clue: Clue) {
        clue.isFound = true
        
        let progress = currentGameProgress
        progress.currentClue += 1
        
        if clue.number < clues.count {
            progress.currentClue = clue.number + 1
        } else {
            progress.isSpecialModeUnlocked = true
        }
        
        
        try? modelContext.save()
    }
}
