struct ARCameraView: View {
    let targetClue: Clue?
    let onClueFound: (Clue) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("📱 Aponte a câmera para encontrar:")
                        .foregroundStyle(.white)
                        .font(.headline)
                    
                    if let clue = targetClue {
                        Text("\(clue.emoji) \(clue.hint)")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Botão temporário para simular encontrar a pista
                    Button("🎯 Simular Encontrar Pista") {
                        if let clue = targetClue {
                            onClueFound(clue)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                .padding()
            }
            .navigationTitle("Procurar Pista")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Voltar") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}