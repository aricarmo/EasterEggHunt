import SwiftUI

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
            ComponentListView(components: viewModel.components)
                .environmentObject(actionManager)
        }
    }
}

struct ComponentListView: View {
    let components: [UIComponent]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(components) { component in
                    ComponentRenderer(component: component)
                }
            }
        }
    }
}
