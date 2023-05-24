//
//  ViewItem.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/22/23.
//

import Foundation
import UIKit

struct WeatherViewItem {

    let temperature: String
    let location: String
    let timeAmPmFormat: String
    let currentDate: String
    let conditionDescription: String
    let conditionImageName: String
    let weatherCondition: Condition
    let isDay: Bool
    let promptMessage: String

    var backgroundColor: UIColor {
        switch weatherCondition {
        case .thunderstorm:
            return WeatherAppDS.Colors.thunderstormBackground
        case .drizzle:
            return WeatherAppDS.Colors.drizzleBackground
        case .snow:
            return WeatherAppDS.Colors.snowBackground
        case .fog:
            return WeatherAppDS.Colors.fogBackground
        case .clearSky, .fewClouds, .rain:
            if isDay {
                    return WeatherAppDS.Colors.clearDayBackground
                } else {
                    return WeatherAppDS.Colors.clearNightBackground
                }
            case .clouds:
                return WeatherAppDS.Colors.cloudBackground
        }
    }

    var darkOrLightMode: UIUserInterfaceStyle {
        switch weatherCondition {
        case .thunderstorm, .snow, .drizzle, .fog, .clouds:
            return .light
        case .clearSky, .fewClouds, .rain:
            if isDay {
                return .light
            } else {
                return .dark
            }
        }
    }
}
