class MovieViewModelFactory {
    static func create(apiKey: String = "SUA_CHAVE_AQUI") -> MovieViewModel {
        // Dependency Injection setup
        let networkService = NetworkService()
        let movieRepository = MovieRepository(
            networkService: networkService,
            apiKey: apiKey
        )
        
        return MovieViewModel(movieRepository: movieRepository)
    }
    
    // Para testes unitários
    static func createForTesting(
        mockRepository: MovieRepositoryProtocol
    ) -> MovieViewModel {
        return MovieViewModel(movieRepository: mockRepository)
    }
}