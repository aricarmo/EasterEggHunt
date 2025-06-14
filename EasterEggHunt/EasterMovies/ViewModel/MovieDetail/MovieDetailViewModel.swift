import SwiftUI
import BDUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var components: [UIComponent] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var movieTitle = ""
    
    func loadMovieDetail(movieId: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                components = try await BDUIMovieAPI().fetchMovieDetail(movieId: movieId)
                
                if let titleComponent = components.first(where: { $0.type == .title }) {
                    movieTitle = titleComponent.properties.text ?? "Filme"
                }
                
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func retry(movieId: String) {
        loadMovieDetail(movieId: movieId)
    }
}
