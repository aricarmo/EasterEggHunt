import Foundation

public struct MoviesNetwork {
    
    public static let version = "1.0.0"
    
    // MARK: - Factory Methods
    
    public static func createTMDBService(apiKey: String) -> TMDBServiceProtocol {
        let networkService = NetworkService()
        let endpointFactory = TMDBEndpointFactory(apiKey: apiKey)
        
        return TMDBService(
            networkService: networkService,
            endpointFactory: endpointFactory
        )
    }
    
    public static func createNetworkService() -> NetworkServiceProtocol {
        return NetworkService()
    }
    
    public static func createTMDBEndpointFactory(apiKey: String) -> TMDBEndpointFactory {
        return TMDBEndpointFactory(apiKey: apiKey)
    }
}
