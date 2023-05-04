//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 8/4/21.
//

import UIKit

struct WeatherModel {
    enum Condition {
        case clearSky, fewClouds, thunderstorm, drizzle, rain, snow, fog, clouds
    }

    var weatherManager = WeatherManager()
    
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
    
    var currentTimeAmPm: String? {
        guard let currentTimeAmPm = converToAmPm(from: currentTime) else {
            return nil
        }
        return currentTimeAmPm
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
    
    var backgroundColor: UIColor {
            switch condition {
            case .thunderstorm:
                return WeatherApp.Colors.thunderstormBackground
            case .drizzle:
                return WeatherApp.Colors.drizzleBackground
            case .snow:
                return WeatherApp.Colors.snowBackground
            case .fog:
                return WeatherApp.Colors.fogBackground
            case .clearSky, .fewClouds, .rain:
                if isDay {
                    return WeatherApp.Colors.clearDayBackground
                } else {
                    return WeatherApp.Colors.clearNightBackground
                }
            case .clouds:
                return WeatherApp.Colors.cloudBackground
        }
    }
    
    var darkOrLightMode: UIUserInterfaceStyle {
        switch condition {
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
    
    
    
    var promptTextMessage: String {
        switch condition {
        case .thunderstorm:
            return "stay safe!"
        case .drizzle:
            return "it's just a drizzle!"
        case .rain:
            return "you better have an umbrella!"
        case .snow:
            return "don't forget your coat!"
        case .fog:
            return "don't worry this fog will pass!"
        case .clearSky:
            if isDay {
                return "have a bright day!"
            } else {
                return "nighty night!"
            }
        case .fewClouds, .clouds:
            return "don't worry this cloud will pass!"
        }
    }
    
    
    // Converter os dados em miliseconds para o formato de hora padrão
    
    private func convert(from timeInMilliseconds: Int, timeZoneInMilliseconds: Int) -> String? {
        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMilliseconds) else {
            return nil
        }
        
        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        
        
        return dateFormatter.string(from: date)
    }
    
    private func converToAmPm(from currentTime: String?) -> String? {
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = "h:mm a"
        
        guard let inStr = currentTime else {
            return nil
        }
        guard let date = inFormatter.date(from: inStr) else {
            return nil
        }
        
        return outFormatter.string(from: date) // -> outputs 04:50
    }
    
    

    
}

