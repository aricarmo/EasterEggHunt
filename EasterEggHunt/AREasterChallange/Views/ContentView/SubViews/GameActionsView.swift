import SwiftUI

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
