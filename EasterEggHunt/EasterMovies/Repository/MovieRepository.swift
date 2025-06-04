import Foundation
import SwiftData
import MoviesNetwork

protocol MovieRepositoryProtocol {
    func fetchEasterMovies() async throws -> [Movie]
}

class MovieRepository: MovieRepositoryProtocol {
    private let networkService: TMDBServiceProtocol
    private let modelContext: ModelContext
    
    init(
        networkService: TMDBServiceProtocol,
        modelContext: ModelContext
    ) {
        self.networkService = networkService
        self.modelContext = modelContext
    }
    
    func fetchEasterMovies() async throws -> [Movie] {
        do {
            let apiMovies = try await networkService.fetchEasterMovies()
            return apiMovies
        } catch {
            print("[MovieRepository] API falhou: \(error.localizedDescription)")
            
            if let cachedMovies = getCachedMovies(from: modelContext),
               !cachedMovies.isEmpty {
                print("[MovieRepository] Usando cache como fallback")
                return cachedMovies
            }
            
            throw error
        }
    }

    private func getCachedMovies(from context: ModelContext) -> [Movie]? {
        do {
            let descriptor = FetchDescriptor<MovieEntity>(
                sortBy: [SortDescriptor(\.voteAverage, order: .reverse)]
            )
            
            let movieEntities = try context.fetch(descriptor)
            
            if movieEntities.isEmpty {
                return nil
            }
            
            return movieEntities.map { $0.toMovie() }
            
        } catch {
            print("[MovieRepository] Erro ao buscar cache: \(error)")
            return nil
        }
    }
}
