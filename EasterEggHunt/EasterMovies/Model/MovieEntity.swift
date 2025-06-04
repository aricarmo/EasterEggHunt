import SwiftUI
import SwiftData
import Foundation

// MARK: - Simple Movie Entity for SwiftData

@Model
class MovieEntity {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var releaseDate: String?
    var voteAverage: Double
    
    init(
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
    
    // Converter para Movie (DTO)
    func toMovie() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage
        )
    }
    
    // Criar MovieEntity a partir de Movie
    static func from(_ movie: Movie) -> MovieEntity {
        MovieEntity(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage
        )
    }
}