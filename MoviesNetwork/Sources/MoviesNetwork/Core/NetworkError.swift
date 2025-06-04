import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError(DecodingError)
    case networkError(Error)
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .serverError(let code):
            return "Erro do servidor: \(code)"
        case .decodingError(let error):
            return "Erro ao processar dados: \(error.localizedDescription)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .noData:
            return "Nenhum dado recebido"
        }
    }
}
