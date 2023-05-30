//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/15/23.
//

import Foundation
import CoreLocation

enum ViewState {
    case none
    case loading
    case success
    case error(WeatherErrorModel)
}

final class WeatherViewModel: WeatherViewModelProtocol {

    weak var delegate: WeatherViewModelDelegate?
    private var weatherModel: WeatherModel?

    let apiService = APIService(service: NetworkingService())

    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }

    init() {
        self.state = .none
    }

    func loadWeatherData(
        cityName: String,
        countryName: String) {

            self.state = .loading
            apiService.getWeather(cityName: cityName, countryName: countryName) { result in
                switch result {
                case .success(let data):
                    print(data)
                    let weatherModel = WeatherModelAdapter(data: data)

                    guard let convertedWeatherModel = weatherModel.getConvertedData() else { return }
                    self.weatherModel = convertedWeatherModel
                    self.state = .success
                case .failure(let error):
                    self.state = .error(WeatherErrorModel(error: error))
                }
            }
        }

    func loadWeatherData(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees) {

            self.state = .loading
            apiService.getWeather(
                latitude: latitude, longitude: longitude
            ) { result in
                switch result {
                case .success(let data):
                    print(data)
                    let weatherModel = WeatherModelAdapter(data: data)

                    guard let convertedWeatherModel = weatherModel.getConvertedData() else { return }

                    self.weatherModel = convertedWeatherModel
                    self.state = .success

                case .failure(let error):
                    self.state = .error(WeatherErrorModel(error: error))
                }
            }
        }

    func getViewItem() -> WeatherViewItem? {
        guard let weatherModel = weatherModel else { return nil }
        let weatherViewItem = WeatherViewItem(
            temperature: weatherModel.temperature,
            location: getLocationLabel(),
            timeAmPmFormat: weatherModel.currentTime,
            currentDate: weatherModel.currentDate,
            conditionDescription: weatherModel.conditionDescription,
            conditionImageName: getWeatherConditionImageName() ?? "",
            weatherCondition: weatherModel.condition,
            isDay: weatherModel.isDay,
            promptMessage: getPromptMessage()
        )

        return weatherViewItem
    }

    private func getPromptMessage() -> String {
        guard let weatherModel = weatherModel else { return "" }
        switch weatherModel.condition {
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
            if weatherModel.isDay {
                return "have a bright day!"
            } else {
                return "nighty night!"
            }
        case .fewClouds, .clouds:
            return "don't worry this cloud will pass!"
        }
    }

//    private func getBackgroundColorCondition() -> BackgroundColorCondition {
//        guard let weatherModel = weatherModel else { return .backgroundColor }
//
//        switch weatherModel.condition {
//            case .thunderstorm:
//                return .thunderstormBackground
//            case .drizzle:
//                return .drizzleBackground
//            case .snow:
//                return .snowBackground
//            case .fog:
//                return .fogBackground
//            case .clearSky, .fewClouds, .rain:
//            if weatherModel.isDay {
//                    return .clearDayBackground
//                } else {
//                    return .clearNightBackground
//                }
//            case .clouds:
//                return .cloudBackground
//        }
//
//    }

    private func getLocationLabel() -> String {
        guard
            let cityName = weatherModel?.cityName,
            let countryName = weatherModel?.countryName
        else { return "" }
        return "\(cityName), \(countryName)"
    }

    private func getWeatherConditionImageName() -> String? {
        guard let weatherModel = weatherModel else { return nil }

        if weatherModel.isDay {
            return "\(weatherModel.condition)" + ".day"
        } else {
            return "\(weatherModel.condition)" + ".night"
        }
    }
}
