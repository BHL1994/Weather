//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Brien Lowe on 7/21/23.
//

import Foundation

struct HourlyForecast: Codable {
    var latitude: Double
    var longitude: Double
    var hour: [Hourly]
    var daily: [Daily]
    var timezoneOffset: Int
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hour = "hourly"
        case daily
        case timezoneOffset = "timezone_offset"
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
