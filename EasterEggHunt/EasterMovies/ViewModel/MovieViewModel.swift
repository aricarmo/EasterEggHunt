import SwiftUI
import Foundation

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    // TMDB API Configuration
    private let tmdbAPIKey = "SUA_CHAVE_AQUI"
    private let baseURL = "https://api.themoviedb.org/3"
    
    // Keywords para filmes de Páscoa
    private let easterKeywords = [
        9923,  // easter-bunny
        15199, // rabbit
        210621 // easter
    ]
    
    func loadEasterMovies() {
        Task {
            await fetchMoviesFromAPI()
        }
    }
    
    // MARK: - API Methods
    private func fetchMoviesFromAPI() async {
        // Se não tiver API key válida, usar dados mock
        if tmdbAPIKey == "SUA_CHAVE_AQUI" {
            await loadMockMovies()
            return
        }
        
        do {
            var allMovies: [Movie] = []
            
            // Buscar filmes para cada keyword
            for keyword in easterKeywords {
                let movies = try await fetchMoviesByKeyword(keyword)
                allMovies.append(contentsOf: movies)
            }
            
            // Remover duplicatas e ordenar por rating
            let uniqueMovies = removeDuplicates(from: allMovies)
            let sortedMovies = uniqueMovies.sorted { $0.voteAverage > $1.voteAverage }
            
            await updateUI {
                self.movies = Array(sortedMovies.prefix(10)) // Top 10
                self.isLoading = false
                self.errorMessage = nil
            }
            
        } catch {
            await updateUI {
                self.errorMessage = "Erro ao carregar filmes: \(error.localizedDescription)"
                self.isLoading = false
                // Carregar dados mock como fallback
                Task { await self.loadMockMovies() }
            }
        }
    }
    
    private func fetchMoviesByKeyword(_ keyword: Int) async throws -> [Movie] {
        let urlString = "\(baseURL)/discover/movie?api_key=\(tmdbAPIKey)&with_keywords=\(keyword)&sort_by=vote_average.desc&vote_count.gte=100"
        
        guard let url = URL(string: urlString) else {
            throw MovieError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
        
        return response.results
    }
    
    private func loadMockMovies() async {
        let mockMovies = [
            Movie(
                id: 1,
                title: "Hop",
                overview: "E.B., o filho adolescente do Coelhinho da Páscoa, vai para Hollywood determinado a se tornar baterista em uma banda de rock.",
                posterPath: "/example1.jpg",
                releaseDate: "2011-04-01",
                voteAverage: 5.5
            ),
            Movie(
                id: 2,
                title: "Rise of the Guardians",
                overview: "Quando um espírito maligno conhecido como Pitch ameaça dominar o mundo, os Guardiões imortais devem se unir pela primeira vez.",
                posterPath: "/example2.jpg",
                releaseDate: "2012-11-21",
                voteAverage: 7.3
            ),
            Movie(
                id: 3,
                title: "Peter Rabbit",
                overview: "Baseado nos contos clássicos de Beatrix Potter sobre um coelho travesso e suas aventuras no jardim do Sr. McGregor.",
                posterPath: "/example3.jpg",
                releaseDate: "2018-02-09",
                voteAverage: 6.6
            ),
            Movie(
                id: 4,
                title: "The Easter Bunny is Comin' to Town",
                overview: "A história da origem do Coelhinho da Páscoa e como ele se tornou um símbolo querido da Páscoa.",
                posterPath: "/example4.jpg",
                releaseDate: "1977-04-06",
                voteAverage: 7.1
            ),
            Movie(
                id: 5,
                title: "Easter Parade",
                overview: "Um musical clássico da MGM sobre um dançarino que treina uma nova parceira para um desfile de Páscoa.",
                posterPath: "/example5.jpg",
                releaseDate: "1948-06-30",
                voteAverage: 7.4
            ),
            Movie(
                id: 6,
                title: "It's the Easter Beagle, Charlie Brown",
                overview: "Charlie Brown e a turma celebram a Páscoa nesta animação clássica dos Peanuts.",
                posterPath: "/example6.jpg",
                releaseDate: "1974-04-09",
                voteAverage: 7.8
            ),
            Movie(
                id: 7,
                title: "Here Comes Peter Cottontail",
                overview: "Peter Cottontail quer ser o #1 dos coelhinhos da Páscoa, mas precisa competir com seu arqui-rival Evil Irontail.",
                posterPath: "/example7.jpg",
                releaseDate: "1971-04-04",
                voteAverage: 6.9
            ),
            Movie(
                id: 8,
                title: "The Tale of Peter Rabbit",
                overview: "Uma adaptação live-action dos adorados contos de Beatrix Potter sobre Peter Rabbit e seus amigos.",
                posterPath: "/example8.jpg",
                releaseDate: "2006-12-28",
                voteAverage: 6.2
            )
        ]
        
        // Simular loading
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        await updateUI {
            self.movies = mockMovies
            self.isLoading = false
            self.errorMessage = nil
        }
    }
    
    // MARK: - Helper Methods
    private func removeDuplicates(from movies: [Movie]) -> [Movie] {
        var uniqueMovies: [Movie] = []
        var seenIds: Set<Int> = []
        
        for movie in movies {
            if !seenIds.contains(movie.id) {
                uniqueMovies.append(movie)
                seenIds.insert(movie.id)
            }
        }
        
        return uniqueMovies
    }
    
    private func updateUI<T>(_ updates: @escaping () -> T) async -> T {
        return await MainActor.run(body: updates)
    }
}

// MARK: - Error Handling
enum MovieError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "Nenhum dado recebido"
        case .decodingError:
            return "Erro ao processar dados"
        }
    }
}