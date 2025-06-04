import Foundation

protocol ConfigurationProtocol {
    var apiKey: String { get }
    var isProduction: Bool { get }
}

struct TMDBConfiguration: ConfigurationProtocol {
    var apiKey: String {
        SecureConfig().tmdbAPIKey
    }
    
    var isProduction: Bool {
        SecureConfig().isProduction
    }
}
