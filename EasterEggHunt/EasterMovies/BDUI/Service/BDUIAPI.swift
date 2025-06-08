import Foundation

struct MovieDetailResponse: Codable {
    let movieId: String
    let version: String
    let metadata: MovieMetadata
    let components: [UIComponent]
}

struct MovieMetadata: Codable {
    let title: String
    let backgroundColor: String
}

actor BDUIMovieAPI {
    private let baseURL = "https://movie-bdui-dcersu2pb-aris-projects-a50e6757.vercel.app"
    private let session = URLSession.shared
    
    func fetchMovieDetail(movieId: String) async throws -> [UIComponent] {
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

enum APIError: LocalizedError {
    case httpError(Int)
    case decodingError
    case networkError
    
    var errorDescription: String? {
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
