import Foundation
import SwiftData
import MoviesNetwork

@MainActor
class MovieViewModelFactory {
    static func create(modelContext: ModelContext,
                       config: TMDBConfigurationProtocol = TMDBConfiguration()) -> MovieViewModel {
        let networkService = MoviesNetwork.createTMDBService(apiKey: config.apiKey)
        
        let movieRepository = MovieRepository(
            networkService: networkService,
            modelContainer: modelContext.container
        )
        
        return MovieViewModel(movieRepository: movieRepository)
    }
}
