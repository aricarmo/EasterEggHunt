import Foundation
import SwiftData
import MoviesNetwork

protocol MovieRepositoryProtocol: Sendable {
    func fetchEasterMovies() async throws -> [Movie]
}

actor MovieRepository: MovieRepositoryProtocol {
    private let networkService: TMDBServiceProtocol
    private let modelContainer: ModelContainer
    
    init(
        networkService: TMDBServiceProtocol,
        modelContainer: ModelContainer
    ) {
        self.networkService = networkService
        self.modelContainer = modelContainer
    }
    
    func fetchEasterMovies() async throws -> [Movie] {
        do {
            let apiMovies = try await networkService.fetchEasterMovies()
            return apiMovies
        } catch {
            print("[MovieRepository] API falhou: \(error.localizedDescription)")
            
            if let cachedMovies = await getCachedMovies(),
               !cachedMovies.isEmpty {
                print("[MovieRepository] Usando cache como fallback")
                return cachedMovies
            }
            
            throw error
        }
    }

    private func getCachedMovies() async -> [Movie]? {
        return await withCheckedContinuation { continuation in
            Task { @MainActor in
                
                let context = ModelContext(modelContainer)
                let result = getCachedMovies(from: context)
                continuation.resume(returning: result)
            }
        }
    }
    
    @MainActor
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
