struct ClueRowView: View {
    let clue: Clue
    let isAccessible: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Pista \(clue.number)")
                            .font(.headline)
                            .foregroundStyle(isAccessible ? .primary : .secondary)
                        
                        Spacer()
                        
                        Text(clue.emoji)
                            .font(.title2)
                    }
                    
                    if isAccessible {
                        Text(clue.hint)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("🔒 Encontre a pista anterior primeiro")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .italic()
                    }
                }
                
                if !clue.isFound && isAccessible {
                    Image(systemName: "camera.fill")
                        .foregroundStyle(.orange)
                        .font(.title3)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .disabled(!isAccessible || clue.isFound)
    }
    
    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(clue.isFound ? .green : (isAccessible ? .orange : .gray))
            
            Image(systemName: clue.isFound ? "checkmark" : (isAccessible ? "\(clue.number).circle.fill" : "lock.fill"))
                .foregroundStyle(.white)
                .font(.caption.weight(.bold))
        }
    }
}
