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

    func testIsDaytime() {
        weatherData = WeatherData.mock(for: .daytime)
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = weatherModelAdapter.getConvertedData()

        XCTAssertTrue(weatherModel!.isDay)
    }

    func testIsNight() {
        weatherData = WeatherData.mock(for: .night)
        weatherModelAdapter = WeatherModelAdapter(data: weatherData)
        let weatherModel = weatherModelAdapter.getConvertedData()

        XCTAssertFalse(weatherModel!.isDay)
    }
}

extension WeatherData {

    enum DayInterval {
        case daytime, night
    }

    static func mock(for daytime: DayInterval) -> WeatherData {
        var weatherData: WeatherData!

        switch daytime {
        case .daytime:
            weatherData = WeatherData(
                cityName: "Porto",
                main: Main(temperature: 292.7),
                weather: [Weather(description: "clear sky", id: 800)],
                currentTime: 1683652515,
                locationData: LocationData(
                    sunrise: 1683609779,
                    sunset: 1683661130,
                    country: "PT"),
                timezone: 3600)
        case .night:
            weatherData = WeatherData(
                cityName: "Porto",
                main: Main(temperature: 292.7),
                weather: [Weather(description: "clear sky", id: 800)],
                currentTime: 1683654710,
                locationData: LocationData(
                    sunrise: 1683664560,
                    sunset: 1683702434,
                    country: "PT"),
                timezone: 3600)
        }
        return weatherData
    }
}
