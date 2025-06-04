import SwiftUI

@main
struct EasterEggHuntApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MovieEntity.self, Clue.self, GameProgress.self])
    }
}
