//
//  WeatherModelAdapter.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/4/23.
//

import Foundation

struct WeatherModelAdapter {
    enum Condition {
        case clearSky, fewClouds, thunderstorm, drizzle, rain, snow, fog, clouds
    }

    let cityName: String
    let countryName: String
    let currentTemperature: Double
    let currentTimeInMilliseconds: Int
    let timeZoneInMilliseconds: Int
    let sunriseInMilliseconds: Int
    let sunsetInMilliseconds: Int
    let conditionId: Int
    let conditionDescription: String

    init(
        cityName: String,
        countryName: String,
        currentTemperature: Double,
        currentTimeInMilliseconds: Int,
        timeZoneInMilliseconds: Int,
        sunriseInMilliseconds: Int,
        sunsetInMilliseconds: Int,
        conditionId: Int,
        conditionDescription: String
    ) {
        self.cityName = cityName
        self.countryName = countryName
        self.currentTemperature = currentTemperature
        self.currentTimeInMilliseconds = currentTimeInMilliseconds
        self.timeZoneInMilliseconds = timeZoneInMilliseconds
        self.sunriseInMilliseconds = sunriseInMilliseconds
        self.sunsetInMilliseconds = sunsetInMilliseconds
        self.conditionId = conditionId
        self.conditionDescription = conditionDescription
    }


    func getConvertedData() -> WeatherModel? {

        guard let currentTime: String = convert(
            from: currentTimeInMilliseconds,
            timeZoneInMilliseconds: timeZoneInMilliseconds)
        else { return nil }

        guard let sunriseTime: String = convert(
            from: sunriseInMilliseconds,
            timeZoneInMilliseconds: timeZoneInMilliseconds)
        else { return nil }

        guard let sunsetTime: String = convert(
            from: sunsetInMilliseconds,
            timeZoneInMilliseconds: timeZoneInMilliseconds)
        else { return nil }

        guard let currentDate: String = convertToCurrentDate(
            from: currentTimeInMilliseconds,
            timeZoneInMilliseconds: timeZoneInMilliseconds)
        else { return nil }

        let isDay = isDay(
            current: currentTime,
            sunrise: sunriseTime,
            sunset: sunsetTime)

        let weatherModel = WeatherModel(
            cityName: cityName,
            countryName: countryName,
            currentTemperature: currentTemperature,
            currentTime: currentTime,
            sunriseTime: sunriseTime,
            sunsetTime: sunsetTime,
            currentDate: currentDate,
            conditionId: conditionId,
            conditionDescription: conditionDescription,
            isDay: isDay)

        return weatherModel
    }

    private func isDay(current: String, sunrise: String, sunset: String) -> Bool {
        let range = sunrise...sunset

        if range.contains(current) {
            return true
        } else {
            return false
        }
    }


    private func convert(from timeInMilliseconds: Int, timeZoneInMilliseconds: Int) -> String? {

        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMilliseconds) else {
            return nil
        }

        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"


        return dateFormatter.string(from: date)
    }

    private func convertToCurrentDate(from timeInMilliseconds: Int, timeZoneInMilliseconds: Int) -> String? {

        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMilliseconds) else {
            return nil
        }

        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "EEEE, MMM d"
        let dateString = dateFormatter.string(from: date)

        return dateString
    }

}

