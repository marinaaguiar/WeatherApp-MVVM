//
//  APIServiceTests.swift
//  WeatherAppTests
//
//  Created by Marina Aguiar on 5/22/23.
//
@testable import WeatherApp
import XCTest

final class APIServiceTests: XCTestCase {

    var apiService: APIService!

    override func setUp() {
        super.setUp()
        apiService = APIService()
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }

    func testRequestDataForCity() {
        let expectation = XCTestExpectation(description: "getWeatherData")
        let weatherData = WeatherData.mock()

        apiService.getWeather(
            cityName: "Porto",
            countryName: "PT") { result in

                switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    expectation.fulfill()

                case .failure(let error):
                    XCTFail("API request failed with error: \(error)")
                    expectation.fulfill()
                }
            }
        wait(for: [expectation], timeout: 2.0)
    }

}
