//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Brien Lowe on 7/21/23.
//

import Foundation
import CoreLocation

struct Forecast: Codable {
    var latitude: Double
    var longitude: Double
    var hourly: [Hourly]
    var daily: [Daily]
    var timezoneOffset: Int
    var current: Current
    var name: String!
    var userLocation: CLLocation?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hourly
        case daily
        case timezoneOffset = "timezone_offset"
        case current
        case name
    }
    
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("forecasts").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    static func saveForecasts(forecast: [Forecast]){
        let encoder = PropertyListEncoder()
        
        do{
            let encodedForecast = try encoder.encode(forecast)
            try encodedForecast.write(to: Forecast.archiveURL)
        } catch {
            print("Error saving forecasts")
        }

    }
    
    static func loadForecasts() -> [Forecast]? {
        guard let forecastData = try? Data(contentsOf: Forecast.archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedForecast = try decoder.decode([Forecast].self, from: forecastData)
            
            return decodedForecast
        } catch {
            print("Error loading forecasts")
            return nil
        }

    }
}

struct Hourly: Codable {
    var dateTime: Int
    var temp: Double
    var weather: [WeatherIcon]

    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temp
        case weather
    }
}

struct Daily: Codable {
    var dateTime: Int
    var temp: Temp
    var dailyWeather: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temp
        case dailyWeather = "weather"
    }
}

struct Current: Codable {
    var dateTime: Int
    var sunrise: Int
    var sunset: Int
    var temp: Double
    var feelsLike: Double
    var humidity: Int
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case humidity
        case weather
    }
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct Temp: Codable {
    var tempMin: Double
    var tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "min"
        case tempMax = "max"
    }
}

struct DailyWeather: Codable {
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case icon
    }
}

struct WeatherIcon: Codable {
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case icon
    }
}



