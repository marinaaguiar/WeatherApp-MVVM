//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Marina Aguiar on 4/16/23.
//
@testable import WeatherApp
import XCTest

final class WeatherModelAdapterTests: XCTestCase {

    var weatherModelAdapter: WeatherModelAdapter!
    var weatherData: WeatherData!

    override func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testIsDaytime() throws {
        weatherData = WeatherData.mock(for: .daytime)
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = try XCTUnwrap(weatherModelAdapter.getConvertedData())

        XCTAssertTrue(weatherModel.isDay)
    }

    func testIsNight() {
        weatherData = WeatherData.mock(for: .night)
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = weatherModelAdapter.getConvertedData()

        XCTAssertFalse(weatherModel!.isDay)
    }

    func testCurrentDateConversion() {
        weatherData = WeatherData.mock()
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = weatherModelAdapter.getConvertedData()

        XCTAssertEqual(weatherModel?.currentDate, "Tuesday, May 16")
    }

    func testCurrentTimeConversion() {
        weatherData = WeatherData.mock()
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = weatherModelAdapter.getConvertedData()

        XCTAssertEqual(weatherModel?.currentTime, "14:25")
    }
}

extension WeatherData {

    enum DayInterval {
        case daytime, night
    }

    static func mock(for daytime: DayInterval = .daytime) -> WeatherData {
        var weatherData: WeatherData!

        switch daytime {
        case .daytime:
            weatherData = WeatherData(
                cityName: "Porto",
                main: Main(temperature: 292.7),
                weather: [Weather(description: "clear sky", id: 800)],
                currentTime: 1684243544,
                locationData: LocationData(
                    sunrise: 1684217700,
                    sunset: 1684269960,
                    country: "PT"),
                timezone: 3600)
        case .night:
            weatherData = WeatherData(
                cityName: "Porto",
                main: Main(temperature: 292.7),
                weather: [Weather(description: "clear sky", id: 800)],
                currentTime: 1684271700,
                locationData: LocationData(
                    sunrise: 1684217700,
                    sunset: 1684269960,
                    country: "PT"),
                timezone: 3600)
        }
        return weatherData
    }
}

