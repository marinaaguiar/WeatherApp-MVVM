//
//  APIService.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/4/23.
//

import Foundation
import CoreLocation

class APIService {

  private var service: NetworkingServiceProtocol

  init(service: NetworkingServiceProtocol) {
    self.service = service
  }

  func getWeather(
    cityName: String,
    countryName: String,
    completion: @escaping ((Result<WeatherData, APIError>) -> Void)
  ) {

    guard let url = APIEndpoint.weatherURL(
      cityName: cityName,
      countryName: countryName
    )
    else {
      completion(.failure(APIError.failedToConstructURL))
      return
    }
    print("Debug print: \(url)")

    apiGet(url: url, completion: completion)
  }

  func getWeather(
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees,
    completion: @escaping ((Result<WeatherData, APIError>) -> Void)
  ) {

    guard let url = APIEndpoint.weatherURL(
      latitude: latitude,
      longitude: longitude)
    else {
      completion(.failure(APIError.failedToConstructURL))
      return
    }
    print("Debug print: \(url)")

    apiGet(url: url, completion: completion)
  }

  private func apiGet(url: URL, completion: @escaping (Result<WeatherData, APIError>) -> Void) {
    self.service.fetchGenericData(url: url) { (result: Result<WeatherData, Error>) in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error as! APIError))
      }
    }
  }
}
