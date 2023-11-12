//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 11/5/23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let openWeatherController = OpenWeatherController()

    
    func configureCollectionViewCell(with hourlyForecastData: HourlyForecast, _ index: Int){
        let time = hourlyForecastData.hour[index+1].dateTime
        timeLabel.text = convertTime(timestamp: time, hourlyForecastData: hourlyForecastData)
        Task{
            do {
                let image = hourlyForecastData.hour[index+1].weather[0].icon
                let weatherImage = try await openWeatherController.fetchImage(icon: image)
                iconLabel.image = weatherImage
            } catch {
                print("Error fetching Image")
            }
        }
        let temperature = hourlyForecastData.hour[index].temp
        temperatureLabel.text = String(format: "%.0f", temperature) + "°"
    }
    
    func convertTime(timestamp: Int, hourlyForecastData: HourlyForecast) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        let offset = hourlyForecastData.timezoneOffset
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.dateFormat = "h a"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
}
