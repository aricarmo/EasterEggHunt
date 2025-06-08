import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.circle")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            
            Text("Nenhum filme encontrado")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Verifique sua conexão e tente novamente")
                .font(.body)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
