import Foundation

struct TMDBEndpoint: APIEndpoint {
    private let apiKey: String
    private let endpoint: String
    private let parameters: [String: String]
    
    init(apiKey: String, endpoint: String, parameters: [String: String] = [:]) {
        self.apiKey = apiKey
        self.endpoint = endpoint
        self.parameters = parameters
    }
    
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        endpoint
    }
    
    var queryItems: [URLQueryItem]? {
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        return items
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
