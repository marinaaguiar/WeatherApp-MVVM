//
//  APIService.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/4/23.
//

import Foundation
import CoreLocation

private struct EndPoint {

    enum QueryItemKey: String {
        case cityName = "q"
        case countryName = "country"
        case latitude = "lat"
        case longitude = "lon"
    }

    static func baseURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"

        components.queryItems = [
            URLQueryItem(name: "appid", value: APIConstant.apiKey),
            URLQueryItem(name: "units", value: "metric"),
        ]
        return components
    }

    static func weatherURL(
        cityName: String,
        countryName: String
    ) -> URL? {
        var components = baseURLComponents()

        components.queryItems?.append(contentsOf: [
            URLQueryItem(
                name: QueryItemKey.cityName.rawValue,
                value: cityName),
            URLQueryItem(
                name: QueryItemKey.countryName.rawValue,
                value: countryName)
        ])

        return components.url
    }

    static func weatherURL(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) -> URL? {
        var components = baseURLComponents()

        components.queryItems?.append(contentsOf: [
            URLQueryItem(
                name: QueryItemKey.latitude.rawValue,
                value: "\(latitude)"),
            URLQueryItem(
                name: QueryItemKey.longitude.rawValue,
                value: "\(longitude)")
        ])

        return components.url
    }
}

class APIService {

    enum NetworkingError: Error {
        case failedToGetData
    }

    enum APIError: Error {
        case failedToConstructURL
        case failedToEncoding
    }

    func getWeather(
        cityName: String,
        countryName: String,
        completion: @escaping ((Result<WeatherData, Error>) -> Void)
    ) {

        guard let url = EndPoint.weatherURL(
            cityName: cityName,
            countryName: countryName
        )
        else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print("Debug print: \(url)")

        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func getWeather(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping ((Result<WeatherData, Error>) -> Void)
    ) {

        guard let url = EndPoint.weatherURL(
            latitude: latitude,
            longitude: longitude)
        else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print("Debug print: \(url)")

        NetworkingService().fetchGenericData(url: url, completion: completion)
    }
}