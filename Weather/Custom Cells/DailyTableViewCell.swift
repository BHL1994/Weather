//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 11/12/23.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    
    let openWeatherController = OpenWeatherController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureDailyCell(with hourlyForecastData: HourlyForecast, _ index: Int){
        let day = hourlyForecastData.daily[index].dateTime
        dayLabel.text = convertTimeToDay(timestamp: day, hourlyForecastData: hourlyForecastData)
        Task {
            do {
                let image = hourlyForecastData.daily[index].dailyWeather[0].icon
                let weatherimage = try await openWeatherController.fetchImage(icon: image)
                weatherIcon.image = weatherimage
            } catch {
                print("Error fetching Image")
            }
        }
        let temperatureLow = hourlyForecastData.daily[index].temp.tempMin
        temperatureLowLabel.text = String(format: "%.0f", temperatureLow) + "°"
        let temperatureHigh = hourlyForecastData.daily[index].temp.tempMax
        temperatureHighLabel.text = String(format: "%.0f", temperatureHigh) + "°"
    }
    
    func convertTimeToDay(timestamp: Int, hourlyForecastData: HourlyForecast) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        let offset = hourlyForecastData.timezoneOffset
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.dateFormat = "E"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }

}
