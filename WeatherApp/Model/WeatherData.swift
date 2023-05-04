//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 7/30/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let dt: Int
    let sys: LocationData
    let timezone: Int

}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}


struct LocationData: Codable {
    let sunrise: Int
    let sunset: Int
    let country: String
}
