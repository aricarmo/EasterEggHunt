import SwiftUI

struct HeaderView: View {
    let gameProgress: GameProgress
    let clues: [Clue]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Encontre as pistas escondidas! 🥚")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            ProgressView(
                value: Double(gameProgress.totalFound),
                total: 4.0
            )
            .tint(.orange)
            
            Text("\(gameProgress.totalFound)/\(clues.count) pistas encontradas")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
