//
//  WeatherProtocols.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/15/23.
//

import Foundation
import CoreLocation

protocol WeatherViewModelProtocol: AnyObject {

    func loadWeatherData(cityName: String, countryName: String)
    func loadWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

protocol WeatherViewModelDelegate: AnyObject {

    func didUpdate(with state: ViewState)
}
