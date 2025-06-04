
import Foundation

// MARK: - Secure Configuration Manager (Info.plist Method)

class SecureConfig {
    static let shared = SecureConfig()
    
    private init() {}
    
    // MARK: - API Key from Info.plist
    
    var tmdbAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              !key.isEmpty,
              key != "SUA_API_KEY_REAL_AQUI" else {
            print("⚠️ TMDB API Key não encontrada no Info.plist. Usando modo mock.")
            return ""
        }
        return key
    }
    
    // MARK: - Validation
    
    var isAPIKeyValid: Bool {
        let key = tmdbAPIKey
        return !key.isEmpty && key.count > 10 && key != "SUA_API_KEY_REAL_AQUI"
    }
    
    // MARK: - Base URL
    
    var tmdbBaseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    // MARK: - Environment Detection
    
    var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
}