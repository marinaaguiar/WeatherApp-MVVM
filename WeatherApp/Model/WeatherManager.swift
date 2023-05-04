//
//  WeatherManager2.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 9/7/21.
//

import Foundation
import CoreLocation

enum WeatherManagerError: Error {
    case failToGetUrl
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func buildURL(queryItems: [URLQueryItem]) -> URL? {
        var componentBuilder = URLComponents()

        componentBuilder.scheme = "https"
        componentBuilder.host = "api.openweathermap.org"
        componentBuilder.path = "/data/2.5/weather"

        componentBuilder.queryItems = [
            URLQueryItem(name: "appid", value: APIConstant.apiKey),
            URLQueryItem(name: "units", value: "metric"),
        ] + queryItems

        return componentBuilder.url
    }
    
    func fetchWeather(cityName: String, countryName: String) {
        
        guard let cityUrl = self.buildURL(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "country", value: countryName)
        ]) else {
            delegate?.didFailWithError(error: WeatherManagerError.failToGetUrl)
            return
        }
        print(cityUrl)

        performRequest(with: cityUrl)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        guard let locationUrl = self.buildURL(queryItems: [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")])
              else {
                delegate?.didFailWithError(error: WeatherManagerError.failToGetUrl)
                return
                }
        performRequest(with: locationUrl)
    }
    
    func performRequest(with url: URL) {
        
    //MARK: 1. Create a URLSession
        let session = URLSession(configuration: .default)
        
    //MARK: 2. Give the session a task
        let task = session.dataTask(with: url, completionHandler: handleRequestData)
        
    // MARK: 3. Start the task
        task.resume()
    }
    
    func handleRequestData(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            if let weather = self.parseJSON(safeData) {
                delegate?.didUpdateWeather(self, weather: weather)
            }
        }
    }
    
    // MARK: - parseJSON

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(WeatherData.self, from: weatherData)
            
            // MARK:  Extract API data
            
            let cityName = decoded.name
            let countryName = decoded.sys.country
            let currentTemperature = decoded.main.temp
            let currentTimeInMilliseconds = decoded.dt
            let timeZoneInMilliseconds = decoded.timezone
            let sunriseInMilliseconds = decoded.sys.sunrise
            let sunsetInMilliseconds = decoded.sys.sunset
            let conditionDescription = decoded.weather[0].description
            let id = decoded.weather[0].id
            
            
            // MARK:- Extract the values of standard date format
            
            guard let currentTime: String = convert(from: currentTimeInMilliseconds,
                                                   timeZoneInMillisseconds: timeZoneInMilliseconds) else { abort() }
            
            guard let sunriseTime: String = convert(from: sunriseInMilliseconds,
                                                    timeZoneInMillisseconds: timeZoneInMilliseconds) else { abort() }
            
            guard let sunsetTime: String = convert(from: sunsetInMilliseconds,
                                                   timeZoneInMillisseconds: timeZoneInMilliseconds) else { abort() }
            
            guard let currentDate: String = convertToCurrentDate(from: currentTimeInMilliseconds,
                                                                    timeZoneInMillisseconds: timeZoneInMilliseconds) else { abort() }
            
            // MARK: Check
           
            let isDay = isDay(current: currentTime, sunrise: sunriseTime, sunset: sunsetTime)
            
            let weather = WeatherModel(cityName: cityName, countryName: countryName,currentTemperature: currentTemperature, currentTime: currentTime, sunriseTime: sunriseTime, sunsetTime: sunsetTime, currentDate: currentDate, conditionId: id, conditionDescription: conditionDescription, isDay: isDay)
            
            print(weather.conditionId)
            print(weather.conditionDescription)
            print(isDay)
            print(cityName)
            print(currentTime)
            print(sunriseTime)
            print(sunsetTime)
            print(currentDate)
            print(weather.temperature)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
        
    }
    
    
    // MARK: - Convert the data in milliseconds for a standard date format
    
    func convert(from timeInMilliseconds: Int, timeZoneInMillisseconds: Int) -> String? {
        
        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMillisseconds) else {
            return nil
        }
        
        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        
        
        return dateFormatter.string(from: date)
    }
    
    func convertToCurrentDate(from timeInMilliseconds: Int, timeZoneInMillisseconds: Int) -> String? {
        
        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInMillisseconds) else {
            return nil
        }
        
        let date = Date(timeIntervalSince1970: Double(timeInMilliseconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "EEEE, MMM d"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    // MARK: - Check if is Day or Night
    
    func isDay(current: String, sunrise: String, sunset: String) -> Bool {
        let range = sunrise...sunset
        
        if range.contains(current) {
            return true
        } else {
            return false
        }
        
    }

}
