import Foundation

protocol TMDBConfigurationProtocol {
    var apiKey: String { get }
    var isProduction: Bool { get }
}

struct TMDBConfiguration: TMDBConfigurationProtocol {
    var apiKey: String {
        SecureConfig().tmdbAPIKey
    }
    
    var isProduction: Bool {
        SecureConfig().isProduction
    }
}
