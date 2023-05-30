//
//  APIEndpointTests.swift
//  WeatherAppTests
//
//  Created by Marina Aguiar on 5/24/23.
//

@testable import WeatherApp
import XCTest

final class APIEndpointTests: XCTestCase {

  var baseURL: URLComponents?

  override func setUp() {
    super.setUp()
    baseURL = APIEndpoint.baseURLComponents()
  }

  override func tearDown() {
    baseURL = nil
    super.tearDown()
  }

  func testBaseURLIsValid() {
    guard let baseURL = baseURL else {
      XCTFail("Invalid URL")
      return
    }
    XCTAssertEqual(baseURL.host!.description, "api.openweathermap.org")
    XCTAssertEqual(baseURL.scheme!.description, "https")
    XCTAssertEqual(baseURL.path.description, "/data/2.5/weather")
    XCTAssertEqual(baseURL.queryItems?[0].description, "appid=\(APIConstant.apiKey)")
    XCTAssertEqual(baseURL.queryItems?[1].description, "units=metric")
  }

  func testWeatherURLForCityNameIsValid() {
    let weatherURL = APIEndpoint.weatherURL(cityName: "Porto", countryName: "PT")

    XCTAssertEqual(weatherURL?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?appid=\(APIConstant.apiKey)&units=metric&q=Porto&country=PT")
  }

  func testWeatherURLForLocationIsValid() {
    let weatherURL = APIEndpoint.weatherURL(latitude: 41.15, longitude: -8.61024)

    XCTAssertEqual(weatherURL?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?appid=\(APIConstant.apiKey)&units=metric&lat=41.15&lon=-8.61024")
  }
}
