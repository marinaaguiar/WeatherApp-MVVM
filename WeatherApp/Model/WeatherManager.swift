//
//  WeatherManager2.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 9/7/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {

    enum WeatherManagerError: Error {
        case failToGetUrl
        case failedToEncoding
    }

    var delegate: WeatherManagerDelegate?
    private let apiService = APIService()

    func fetchWeather(cityName: String, countryName: String) {

        apiService.getWeather(cityName: cityName, countryName: countryName) { result in
            switch result {
            case .success(let data):
                print(data)

                let weatherModel = WeatherModelAdapter(data: data)

                guard let convertedWeatherModel = weatherModel.getConvertedData() else { return }

                delegate?.didUpdateWeather(self, weather: convertedWeatherModel)

            case .failure(_):
                delegate?.didFailWithError(error: WeatherManagerError.failToGetUrl)
            }
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {

        apiService.getWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let data):
                print(data)

                let weatherModel = WeatherModelAdapter(data: data)

                guard let convertedWeatherModel = weatherModel.getConvertedData() else { return }

                delegate?.didUpdateWeather(self, weather: convertedWeatherModel)

            case .failure(_):
                delegate?.didFailWithError(error: WeatherManagerError.failToGetUrl)
            }
        }
    }

}
