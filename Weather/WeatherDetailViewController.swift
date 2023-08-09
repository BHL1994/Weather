//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var currentWeatherData: CurrentWeather?
    var hourlyForecastData: HourlyForecast?
    let openWeatherController = OpenWeatherController()
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var weatherDetailLabel: UILabel!
    @IBOutlet var temperatureHighLabel: UILabel!
    @IBOutlet var temperatureLowLabel: UILabel!
    
    
    @IBOutlet var hourLabels: [UILabel]!
    @IBOutlet var temperatureLabels: [UILabel]!
    
    @IBOutlet var weatherIcons: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        updateUI()
    }
    
    func updateUI() {
        if let temperature = currentWeatherData?.main.temp {
            temperatureLabel.text = String(format: "%.0f", temperature)
        }
        locationNameLabel.text = currentWeatherData?.name
        weatherDetailLabel.text = currentWeatherData?.weather[0].description
        
        if let tempMax = currentWeatherData?.main.tempMax {
            temperatureHighLabel.text = String(format: "%.0f", tempMax)
        }
        if let tempMin = currentWeatherData?.main.tempMin {
            temperatureLowLabel.text = String(format: "%.0f", tempMin)
        }
        
        if let time = hourlyForecastData?.hour[0].dateTime {
            hourLabels[0].text = String(time)
        }
        
        for index in hourLabels.indices {
            if let time = hourlyForecastData?.hour[index+1].dateTime {
                hourLabels[index].text = convertTime(timestamp: time)
            }
            Task {
                do {
                    if let image = hourlyForecastData?.hour[index+1].weather[0].icon {
                        let weatherImage = try await openWeatherController.fetchImage(icon: image)
                        weatherIcons[index].image = weatherImage
                    }
                } catch {
                    print("Error fetching Image")
                }
            }
        }
    }
        
    func convertTime(timestamp: Int) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT-0400")
        dateFormatter.dateFormat = "H: mm a"
        let newDate = dateFormatter.string(from: date)
        
        return newDate
    }
    
}
