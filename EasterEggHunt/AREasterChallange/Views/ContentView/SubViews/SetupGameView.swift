import SwiftUI

struct SetupGameView: View {
    let onSetup: () -> Void
    
    var body: some View {
        Button("Iniciar Caça aos Ovos") {
            onSetup()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}
