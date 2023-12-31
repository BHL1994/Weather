//
//  OpenWeatherController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/4/23.
//

import Foundation
import UIKit

class OpenWeatherController {
    
    enum WeatherError: Error, LocalizedError {
        case weatherNotFound
        case imageDataMissing
    }
    
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    
    func fetchForecast(_ latitude: Double, _ longitude: Double) async throws -> Forecast {
        let weatherForecastURL = baseURL.appendingPathComponent("onecall")
        
        var components = URLComponents(url: weatherForecastURL, resolvingAgainstBaseURL: true)!
        
        components.queryItems = ["lat": String(latitude), "lon": String(longitude), "APPID":"245360e32e91a426865d3ab8daab5bf3", "units":"imperial", "exclude": "minutely,alerts"].map { URLQueryItem(name: $0.key, value: $0.value)}
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.weatherNotFound
              }
        print(components.url)
        let jsonDecoder = JSONDecoder()
        let weatherInfo = try jsonDecoder.decode(Forecast.self, from: data)
        return (weatherInfo)

    }
    
    func fetchImage(icon: String) async throws -> UIImage {
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.imageDataMissing
              }
        guard let image = UIImage(data: data) else {
            throw WeatherError.imageDataMissing
        }
        
        
        
        return image
    }
}
