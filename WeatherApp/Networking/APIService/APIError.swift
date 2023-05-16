//
//  APIError.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/16/23.
//

import Foundation

enum APIError: Error {

    case unknown
    case noInternetConnection
    case failedRequest
    case invalidResponse

    var message: String {
        switch self {
        case .unknown, .failedRequest, .invalidResponse:
            return " Please try again later or contact our support team for further assistance."
        case .noInternetConnection:
            return "Please check your internet connection and try again."
        }
    }
    var title: String {
        switch self {
        case .unknown, .failedRequest, .invalidResponse:
            return "The server encountered an unexpected error while processing your request."
        case .noInternetConnection:
            return "We're sorry, but there seems to be an issue with your network connection."
        }
    }
}
