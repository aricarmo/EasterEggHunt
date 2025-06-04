import Foundation

protocol ConfigurationProtocol {
    var apiKey: String { get }
    var isProduction: Bool { get }
}

struct TMDBConfiguration: ConfigurationProtocol {
    var apiKey: String {
        SecureConfig.shared.tmdbAPIKey
    }
    
    var isProduction: Bool {
        SecureConfig.shared.isProduction
    }
}
