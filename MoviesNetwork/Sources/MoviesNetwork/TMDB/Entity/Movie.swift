import Foundation

public struct Movie: Codable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let releaseDate: String?
    public let voteAverage: Double
    
    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String? = nil,
        releaseDate: String? = nil,
        voteAverage: Double
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
    
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - TMDB Response

public struct TMDBResponse: Codable, Sendable {
    public let results: [Movie]
    public let totalResults: Int
    
    public init(results: [Movie], totalResults: Int) {
        self.results = results
        self.totalResults = totalResults
    }
    
    private enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}
