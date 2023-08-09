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
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case hour = "hourly"
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

struct WeatherIcon: Codable {
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case icon
    }
}
