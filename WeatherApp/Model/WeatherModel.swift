//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 8/4/21.
//

import UIKit

enum Condition {
    case clearSky, fewClouds, thunderstorm, drizzle, rain, snow, fog, clouds
}

struct WeatherModel {

    let cityName: String
    let countryName: String
    let currentTemperature: Double
    let currentTime: String
    let sunriseTime: String
    let sunsetTime: String
    let currentDate: String
    let conditionId: Int
    let conditionDescription: String
    let isDay: Bool
    
    var temperature: String {
        return String(format: "%.0f°C", currentTemperature)
    }

    var condition: Condition {
        switch conditionId {
        case 200...232:
            return .thunderstorm
        case 300...321:
            return .drizzle
        case 500...531:
            return .rain
        case 600...622:
            return .snow
        case 701...781:
            return .fog
        case 800:
            return .clearSky
        case 801...802:
            return .fewClouds
        case 803...804:
            return .clouds
        default:
            return .clouds
        }
    }
}

