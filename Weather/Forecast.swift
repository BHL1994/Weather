//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Brien Lowe on 7/21/23.
//

import Foundation

struct Forecast: Codable {
    var latitude: Double
    var longitude: Double
    var hour: [Hourly]
    var daily: [Daily]
    var timezoneOffset: Int
    var current: Current
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hour = "hourly"
        case daily
        case timezoneOffset = "timezone_offset"
        case current
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
    var weather: [CurrWeather]
    
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


//******************
struct CurrWeather: Codable {
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
