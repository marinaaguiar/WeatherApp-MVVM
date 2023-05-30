//
//  APIServiceTests.swift
//  WeatherAppTests
//
//  Created by Marina Aguiar on 5/22/23.
//
@testable import WeatherApp
import XCTest
import CoreLocation

final class APIServiceTests: XCTestCase {

  var apiService: APIService!
  var networkingService: NetworkingServiceMock!

  override func setUp() {
    super.setUp()
    networkingService = NetworkingServiceMock()
    apiService = APIService(service: networkingService)
  }

  override func tearDown() {
    apiService = nil
    super.tearDown()
  }

  func testRequestDataForCity() {
    let weatherData = WeatherData.mock()

    networkingService.weatherData = weatherData

    apiService.getWeather(
      cityName: "Porto",
      countryName: "PT") { result in

        switch result {
        case .success(let data):
          XCTAssertEqual(data, weatherData)

        case .failure(let error):
          XCTFail("API request failed with error: \(error)")
        }
      }
  }

  func testRequestDataForLocation() {
    let weatherData = WeatherData.mock()

    networkingService.weatherData = weatherData

    let mockLocation = CLLocation(latitude: 41.14961, longitude: -8.61099)

    apiService.getWeather(
      latitude: mockLocation.coordinate.latitude,
      longitude: mockLocation.coordinate.longitude) { result in

        switch result {
        case .success(let data):
          XCTAssertEqual(data, weatherData)

        case .failure(let error):
          XCTFail("API request failed with error: \(error)")
        }
      }
  }

  func testErrorForLocation() {
    let expectedError = APIError.failedRequest

    networkingService.error = expectedError

    let mockLocation = CLLocation(latitude: 41.14961, longitude: -8.61099)

    apiService.getWeather(
      latitude: mockLocation.coordinate.latitude,
      longitude: mockLocation.coordinate.longitude) { result in

        switch result {
        case .success:
          XCTFail("We are waiting an error and we got a data")

        case .failure(let error):
          XCTAssertEqual(error, expectedError)
        }
      }
  }

  func testErrorForCity() {
    let expectedError = APIError.failedRequest

    networkingService.error = expectedError

    apiService.getWeather(
      cityName: "Porto",
      countryName: "PT") { result in

        switch result {
        case .success:
          XCTFail("We are waiting an error and we got a data")

        case .failure(let error):
          XCTAssertEqual(error, expectedError)
        }
      }
  }
}

final class NetworkingServiceMock: NetworkingServiceProtocol {

  var weatherData: WeatherData?
  var error: Error?

  func fetchGenericData<T: Decodable>(
    url: URL,
    completion: @escaping (Result<T, Error>) -> Void) {

      if let weatherData = weatherData {
        completion(.success(weatherData as! T))
      }
      else if let error = error {
        completion(.failure(error))
      }
    }
}
