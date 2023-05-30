//
//  APIError.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/16/23.
//

import Foundation

enum APIError: Error, Equatable {

    case unknown
    case noInternetConnection
    case failedRequest
    case invalidResponse
    case failedToConstructURL
    case networkingError
}
