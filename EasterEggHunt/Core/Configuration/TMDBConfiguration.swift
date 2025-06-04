//
//  ConfigurationProtocol.swift
//  EasterEggHunt
//
//  Created by Arilson Simplicio on 03/06/25.
//


import Foundation

// MARK: - Configuration Protocol

protocol ConfigurationProtocol {
    var apiKey: String { get }
    var baseURL: String { get }
    var isProduction: Bool { get }
}

// MARK: - TMDB Configuration Implementation

struct TMDBConfiguration: ConfigurationProtocol {
    var apiKey: String {
        SecureConfig.shared.tmdbAPIKey
    }
    
    var baseURL: String {
        SecureConfig.shared.tmdbBaseURL
    }
    
    var isProduction: Bool {
        SecureConfig.shared.isProduction
    }
}