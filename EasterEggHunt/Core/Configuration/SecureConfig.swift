import Foundation


struct SecureConfig {
    var tmdbAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              !key.isEmpty else {
            return ""
        }
        return key
    }
    
    var isAPIKeyValid: Bool {
        let key = tmdbAPIKey
        return !key.isEmpty && key.count > 10
    }
    
    var tmdbBaseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var isProduction: Bool {
        true 
    }
}
