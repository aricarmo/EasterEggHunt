import Foundation

public struct MovieDetailResponse: Codable {
    public let movieId: String
    public let version: String
    public let metadata: MovieMetadata
    public let components: [UIComponent]
}

public struct MovieMetadata: Codable {
    public let title: String
    public let backgroundColor: String
}

public actor BDUIMovieAPI {
    private let baseURL = "https://movie-bdui-59if4wut5-aris-projects-a50e6757.vercel.app"
    private let session = URLSession.shared
    
    public init() {}
    
    public func fetchMovieDetail(movieId: String) async throws -> [UIComponent] {
        guard let url = URL(string: "\(baseURL)/api/movie/\(movieId)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard 200...299 ~= httpResponse.statusCode else {
                throw APIError.httpError(httpResponse.statusCode)
            }
        }
        
        let movieResponse = try JSONDecoder().decode(MovieDetailResponse.self, from: data)
        
        return movieResponse.components
    }
}

public enum APIError: LocalizedError {
    case httpError(Int)
    case decodingError
    case networkError
    
    public var errorDescription: String? {
        switch self {
        case .httpError(let code):
            return "Erro HTTP: \(code)"
        case .decodingError:
            return "Erro ao processar dados"
        case .networkError:
            return "Erro de conexão"
        }
    }
}
