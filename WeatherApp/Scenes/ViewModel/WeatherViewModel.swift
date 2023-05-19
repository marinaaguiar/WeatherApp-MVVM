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
    case success(WeatherModel)
    case error(Error)
}

final class WeatherViewModel: WeatherViewModelProtocol {

    weak var delegate: WeatherViewModelDelegate?
    private var weatherModel: WeatherModel!

    let apiService = APIService()

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
                    self.state = .success(convertedWeatherModel)
                    self.weatherModel = convertedWeatherModel
                case .failure(let error):
                    self.state = .error(error)
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

                    self.state = .success(convertedWeatherModel)
                    self.weatherModel = convertedWeatherModel

                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }

    func getTemperature() -> String {
        return weatherModel?.temperature ?? ""
    }

    func getLocationLabel() -> String {
        guard
            let cityName = weatherModel?.cityName,
            let countryName = weatherModel?.countryName
        else { return "" }
        return "\(cityName), \(countryName)"
    }

    func getCurrentTimeAmPmFormat() -> String {
        return weatherModel?.currentTimeAmPm ?? ""
    }

    func getCurrentDate() -> String {
        return weatherModel?.currentDate ?? ""
    }

    func getConditionDescription() -> String {
        return weatherModel?.conditionDescription ?? ""
    }

    func getWeatherConditionImageName() -> String {

        if weatherModel.isDay {
            return "\(weatherModel.condition)" + ".day"
        } else {
            return "\(weatherModel.condition)" + ".night"
        }
    }

    func getWeatherCondition() -> Condition {
        return weatherModel?.condition ?? .clearSky
    }

    func isDay() -> Bool {
        return weatherModel?.isDay ?? true
    }

}
