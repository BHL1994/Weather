//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 11/5/23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let openWeatherController = OpenWeatherController()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImage.image = nil
    }
    
    func configureCollectionViewCell(with forecastData: Forecast, _ index: Int){
        let time = forecastData.hourly[index].dateTime
        timeLabel.text = convertTime(timestamp: time, forecastData: forecastData)
        Task{
            do {
                let image = forecastData.hourly[index].weather[0].icon
                let weatherImage = try await openWeatherController.fetchImage(icon: image)
                iconImage.image = weatherImage
            } catch {
                print("Error fetching Image")
            }
        }
        let temperature = forecastData.hourly[index].temp
        temperatureLabel.text = String(format: "%.0f", temperature) + "°"
    }
    
    func convertTime(timestamp: Int, forecastData: Forecast) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        let offset = forecastData.timezoneOffset
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.dateFormat = "h a"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
}
