import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    viewModel.loadEasterMovies()
                }
            } else {
                MovieContentView(movies: viewModel.movies)
            }
        }
        .navigationTitle("🎬 Filmes de Páscoa")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadEasterMovies()
        }
    }
}

// MARK: - Subviews
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("🐰 Carregando filmes de Páscoa...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("Ops! Algo deu errado")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Tentar Novamente") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MovieContentView: View {
    let movies: [Movie]
    
    var body: some View {
        VStack {
            Text("🍿 Filmes perfeitos para assistir na Páscoa!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.secondary)
            
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
}

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

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            // Poster placeholder ou imagem real
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if let releaseDate = movie.releaseDate {
                        Text(String(releaseDate.prefix(4)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}