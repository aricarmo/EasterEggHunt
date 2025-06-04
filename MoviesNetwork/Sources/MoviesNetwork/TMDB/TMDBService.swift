
import Foundation

// MARK: - TMDB Service Implementation

public protocol TMDBServiceProtocol {
    func fetchEasterMovies() async throws -> [Movie]
}

public class TMDBService: TMDBServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let endpointFactory: TMDBEndpointFactory
    
    // Keywords para filmes de Páscoa
    private let easterKeywords = [
        9923,  // easter-bunny
        15199, // rabbit
        210621 // easter
    ]
    
    public init(
        networkService: NetworkServiceProtocol,
        endpointFactory: TMDBEndpointFactory
    ) {
        self.networkService = networkService
        self.endpointFactory = endpointFactory
    }
    
    // MARK: - Public Interface
    
    public func fetchEasterMovies() async throws -> [Movie] {
        var allMovies: [Movie] = []
        
        for keyword in easterKeywords {
            do {
                let endpoint = endpointFactory.discoverMoviesByKeyword(keyword)
                let response: TMDBResponse = try await networkService.request(endpoint)
                allMovies.append(contentsOf: response.results)
            } catch {
                print("Erro ao buscar keyword \(keyword): \(error)")
            }
        }
        
        guard !allMovies.isEmpty else {
            throw NetworkError.noData
        }
        
        return processMovies(allMovies)
    }

    // MARK: - Private Helpers
    
    private func processMovies(_ movies: [Movie]) -> [Movie] {
        let uniqueMovies = removeDuplicates(from: movies)
        let sortedMovies = uniqueMovies.sorted { $0.voteAverage > $1.voteAverage }
        
        return Array(sortedMovies.prefix(10))
    }
    
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
}
