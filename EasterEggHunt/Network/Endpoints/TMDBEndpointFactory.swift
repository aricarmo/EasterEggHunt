import Foundation

struct TMDBEndpoints {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func discoverMoviesByKeyword(_ keyword: Int) -> TMDBEndpoint {
        TMDBEndpoint(
            apiKey: apiKey,
            endpoint: "/discover/movie",
            parameters: [
                "with_keywords": "\(keyword)",
                "sort_by": "vote_average.desc",
                "vote_count.gte": "100"
            ]
        )
    }
    
    func searchMovies(_ query: String) -> TMDBEndpoint {
        TMDBEndpoint(
            apiKey: apiKey,
            endpoint: "/search/movie",
            parameters: ["query": query]
        )
    }
}
