import SwiftUI
import SwiftData

struct MovieListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: MovieViewModel?
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                MovieContentContainer(viewModel: viewModel)
            } else {
                LoadingView()
            }
        }
        .navigationTitle("Filmes de Páscoa")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel == nil {
                setupViewModel()
            }
        }
    }
    
    private func setupViewModel() {
        viewModel = MovieViewModelFactory.create(modelContext: modelContext)
        viewModel?.loadEasterMovies()
    }
}

struct MovieContentContainer: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    viewModel.retry()
                }
            } else {
                MovieContentView(
                    movies: viewModel.movies,
                    isFromCache: viewModel.isFromCache
                )
            }
        }
    }
}
