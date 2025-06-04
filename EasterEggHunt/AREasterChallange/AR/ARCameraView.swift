import SwiftUI

struct ARCameraView: View {
    let targetClue: Clue
    let onClueFound: (Clue) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var isClueFound: Bool = false
    @State private var showCenterCrossHair: Bool = false
    
    var body: some View {
        ZStack {
            ARViewContainer(
                targetClue: targetClue,
                onClueCentered: {
                    withAnimation(.spring()) {
                        isClueFound = true
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        onClueFound(targetClue)
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button("Voltar") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.6))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button("Simular pista encontrada") {
                        onClueFound(targetClue)
                    }
                    .foregroundStyle(.green)
                    .clipShape(Capsule())
                }
                .padding()
                
                Spacer()
                
                if showCenterCrossHair && !isClueFound {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    if isClueFound {
                        VStack {
                            Text("🎉 Pista Encontrada!")
                                .font(.title2.bold())
                                .foregroundStyle(.green)
                            
                            Text("Pista \(targetClue.number) desbloqueada!")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack {
                            Text("Procure a pista:")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            HStack {
                                Text(targetClue.emoji)
                                    .font(.title)
                                
                                Text(targetClue.hint)
                                    .font(.body)
                                    .foregroundStyle(.white)
                            }
                            
                            Text("Centralize na mira para capturar")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}
