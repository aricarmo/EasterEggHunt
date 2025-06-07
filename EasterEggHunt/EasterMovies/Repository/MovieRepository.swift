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
            let movies = try await networkService.fetchEasterMovies()
            Task { await saveCachedMovies(movies) }
            
            return movies
        } catch {
            if let cachedMovies = await getCachedMovies(),
               !cachedMovies.isEmpty {
                return cachedMovies
            }
            
            throw error
        }
    }
    
    @MainActor
    private func getCachedMovies() -> [Movie]? {
        do {
            let context = ModelContext(modelContainer)
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
    
    @MainActor
    private func saveCachedMovies(_ movies: [Movie]) {
        do {
            let context = ModelContext(modelContainer)
            let oldDescriptor = FetchDescriptor<MovieEntity>()
            let oldMovies = try context.fetch(oldDescriptor)
            
            oldMovies.forEach { context.delete($0) }
            
            movies.forEach { movie in
                let entity = MovieEntity.from(movie)
                context.insert(entity)
            }
            
            try context.save()
            
        } catch {
            print("[MovieRepository] Erro ao salvar cache: \(error)")
        }
    }
}
