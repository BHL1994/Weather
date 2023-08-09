//
//  OpenWeather.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/4/23.
//

struct CurrentWeather: Codable {
    var coordinates: Coordinates
    var weather: [Weather]
    var main: Main
    var dt: Int
    var sys: Sys
    var timeZone: Int
    var id: Int
    var name: String
    var cod: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case main
        case dt
        case sys
        case timeZone = "timezone"
        case id
        case name
        case cod
    }
}

struct Coordinates: Codable {
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
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

struct Main: Codable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Sys: Codable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: Int

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case country
        case sunrise
    }
    
}


