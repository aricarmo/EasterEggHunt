import SwiftUI
import BDUI

struct MovieDetailView: View {
    let movieId: String
    @StateObject private var viewModel = MovieDetailViewModel()
    @StateObject private var actionManager = ActionManager()
    
    var body: some View {
        content
            .navigationTitle(viewModel.movieTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if viewModel.components.isEmpty {
                    viewModel.loadMovieDetail(movieId: movieId)
                }
            }
            .refreshable {
                viewModel.loadMovieDetail(movieId: movieId)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.error {
            ErrorView(
                message: error,
                onRetry: {
                    viewModel.retry(movieId: movieId)
                }
            )
        } else {
            BDUIView(components: viewModel.components, actionManager: actionManager)
        }
    }
}
