import Foundation
import SwiftData
import MoviesNetwork

@MainActor
class MovieViewModelFactory {
    static func create(modelContext: ModelContext) -> MovieViewModel {
        let config = TMDBConfiguration()
        let networkService = MoviesNetwork.createTMDBService(apiKey: config.apiKey)
        
        let movieRepository = MovieRepository(
            networkService: networkService,
            modelContext: modelContext
        )
        
        return MovieViewModel(movieRepository: movieRepository)
    }
    
    static func createForTesting(mockRepository: MovieRepositoryProtocol) -> MovieViewModel {
        return MovieViewModel(movieRepository: mockRepository)
    }
}
