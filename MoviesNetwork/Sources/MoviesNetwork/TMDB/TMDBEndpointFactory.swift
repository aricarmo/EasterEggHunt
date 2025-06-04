import Foundation

public struct TMDBEndpointFactory: Sendable {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func discoverMoviesByKeyword(_ keyword: Int) -> TMDBEndpoint {
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
}
