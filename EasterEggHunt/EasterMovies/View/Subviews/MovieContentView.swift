import SwiftUI
import MoviesNetwork

struct MovieContentView: View {
    let movies: [Movie]
    let isFromCache: Bool
    
    var body: some View {
        VStack {
            headerView
            
            if movies.isEmpty {
                EmptyStateView()
            } else {
                List(movies) { movie in
                    MovieRowView(movie: movie)
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Filmes perfeitos para assistir na Páscoa!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            if isFromCache {
                HStack {
                    Image(systemName: "wifi.slash")
                        .foregroundStyle(.orange)
                    Text("Modo offline - dados salvos")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(.orange.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding()
    }
}
