//
//  WeatherModelAdapter.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/4/23.
//

import Foundation

struct WeatherModelAdapter {
    let data: WeatherData!

    init(data: WeatherData) {
        self.data = data
    }

    func getConvertedData() -> WeatherModel? {

        guard let currentTime: String = convertTimeToAmPmFormat(
            from: data.currentTime,
            timeZoneInMilliseconds: data.timezone)
        else { return nil }

        guard let sunriseTime: String = convertTimeToAmPmFormat(
            from: data.locationData.sunrise,
            timeZoneInMilliseconds: data.timezone)
        else { return nil }

        guard let sunsetTime: String = convertTimeToAmPmFormat(
            from: data.locationData.sunset,
            timeZoneInMilliseconds: data.timezone)
        else { return nil }

        guard let currentDate: String = convertToCurrentDate(
            from: data.currentTime,
            timeZoneInMilliseconds: data.timezone)
        else { return nil }

        let weatherModel = WeatherModel(
            cityName: data.cityName,
            countryName: data.locationData.country,
            currentTemperature: data.main.temperature,
            currentTime: currentTime,
            sunriseTime: sunriseTime,
            sunsetTime: sunsetTime,
            currentDate: currentDate,
            conditionId: data.weather[0].id,
            conditionDescription: data.weather[0].description,
            isDay: isCurrentTimeDaytime(
                current: data.currentTime,
                sunrise: data.locationData.sunrise,
                sunset: data.locationData.sunset)
        )

        return weatherModel
    }

    private func isCurrentTimeDaytime(current: Int, sunrise: Int, sunset: Int) -> Bool {
        let range = sunrise...sunset
        return range.contains(current)
    }

    private func convertTimeToAmPmFormat(from timeInMilliseconds: Int, timeZoneInMilliseconds: Int) -> String? {

        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMilliseconds) else {
            return nil
        }

        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "h:mm a"

        return dateFormatter.string(from: date)
    }

    private func convertToCurrentDate(from timeInMilliseconds: Int, timeZoneInMilliseconds: Int) -> String? {

        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMilliseconds) else {
            return nil
        }

        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
}

