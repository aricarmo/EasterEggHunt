import SwiftUI
import Foundation
import MoviesNetwork

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var isFromCache = false
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func loadEasterMovies() {
        Task {
            await performMovieLoad()
        }
    }
    
    func retry() {
        loadEasterMovies()
    }
    
    private func performMovieLoad() async {
        do {
            let fetchedMovies = try await Task.detached {
                return try await self.movieRepository.fetchEasterMovies()
            }.value
            
            await updateUISuccess(movies: fetchedMovies)
        } catch {
             await updateUIError(error: error)
        }
    }
    
    private func updateUILoading() async {
        self.isLoading = true
        self.errorMessage = nil
        self.isFromCache = false
    }
    
    private func updateUISuccess(movies: [Movie]) async {
        self.isLoading = false
        self.movies = movies
        self.errorMessage = nil
        self.isFromCache = isFromCache
    }
    
    private func updateUIError(error: Error) async {
        self.isLoading = false
        self.errorMessage = error.localizedDescription
    }
}


