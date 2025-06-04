//
//  TMDBService.swift
//  MoviesNetwork
//
//  Created by Arilson Simplicio on 04/06/25.
//


import Foundation

// MARK: - TMDB Service Implementation

public class TMDBService: TMDBServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let endpointFactory: TMDBEndpointFactory
    
    // Keywords para filmes de Páscoa
    private let easterKeywords = [
        9923,  // easter-bunny
        15199, // rabbit
        210621 // easter
    ]
    
    public init(
        networkService: NetworkServiceProtocol,
        endpointFactory: TMDBEndpointFactory
    ) {
        self.networkService = networkService
        self.endpointFactory = endpointFactory
    }
    
    // MARK: - Public Interface
    
    public func discoverEasterMovies() async throws -> [Movie] {
        var allMovies: [Movie] = []
        
        // Buscar filmes para cada keyword de Páscoa
        for keyword in easterKeywords {
            do {
                let endpoint = endpointFactory.discoverMoviesByKeyword(keyword)
                let response: TMDBResponse = try await networkService.request(endpoint)
                allMovies.append(contentsOf: response.results)
            } catch {
                print("⚠️ Erro ao buscar keyword \(keyword): \(error)")
                // Continua com outras keywords
            }
        }
        
        guard !allMovies.isEmpty else {
            throw NetworkError.noData
        }
        
        return processMovies(allMovies)
    }
    
    public func searchMovies(query: String) async throws -> [Movie] {
        let endpoint = endpointFactory.searchMovies(query)
        let response: TMDBResponse = try await networkService.request(endpoint)
        return response.results
    }
    
    // MARK: - Private Helpers
    
    private func processMovies(_ movies: [Movie]) -> [Movie] {
        // Remover duplicatas
        let uniqueMovies = removeDuplicates(from: movies)
        
        // Ordenar por rating
        let sortedMovies = uniqueMovies.sorted { $0.voteAverage > $1.voteAverage }
        
        // Retornar top 10
        return Array(sortedMovies.prefix(10))
    }
    
    private func removeDuplicates(from movies: [Movie]) -> [Movie] {
        var uniqueMovies: [Movie] = []
        var seenIds: Set<Int> = []
        
        for movie in movies {
            if !seenIds.contains(movie.id) {
                uniqueMovies.append(movie)
                seenIds.insert(movie.id)
            }
        }
        
        return uniqueMovies
    }
}