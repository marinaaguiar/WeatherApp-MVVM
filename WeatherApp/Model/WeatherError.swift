//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/22/23.
//

import Foundation

struct WeatherErrorModel {
    let title: String
    let message: String

    init(error: APIError) {
        title = WeatherErrorModel.getTitle(for: error)
        message = WeatherErrorModel.getMessage(for: error)
    }
}

private extension WeatherErrorModel {
    private static func getTitle(for error: APIError) -> String {
        switch error {
        case .unknown, .failedRequest, .invalidResponse, .failedToConstructURL, .networkingError:
            return "The server encountered an unexpected error while processing your request."
        case .noInternetConnection:
            return "We're sorry, but there seems to be an issue with your network connection."
        }
    }

    private static func getMessage(for error: APIError) -> String {
        switch error {
        case .unknown, .failedRequest, .invalidResponse, .failedToConstructURL, .networkingError:
            return "Please try again later or contact our support team for further assistance."
        case .noInternetConnection:
            return "Please check your internet connection, make sure your device is connected over Wi-Fi or cellular data and try again."
        }

    }
}
