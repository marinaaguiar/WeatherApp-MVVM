//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 7/30/21.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let cityName: String
    let main: Main
    let weather: [Weather]
    let currentTime: Int
    let locationData: LocationData
    let timezone: Int

    init(
        cityName: String,
        main: Main,
        weather: [Weather],
        currentTime: Int,
        locationData: LocationData,
        timezone: Int
    ) {
        self.cityName = cityName
        self.main = main
        self.weather = weather
        self.currentTime = currentTime
        self.locationData = locationData
        self.timezone = timezone
    }
}

struct Main: Codable, Equatable {
    let temperature: Double
}

struct Weather: Codable, Equatable {
    let description: String
    let id: Int
}

struct LocationData: Codable, Equatable {
    let sunrise: Int
    let sunset: Int
    let country: String
}

private extension WeatherData {
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case currentTime = "dt"
        case locationData = "sys"
        case main, weather, timezone
    }
}

private extension Main {
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
