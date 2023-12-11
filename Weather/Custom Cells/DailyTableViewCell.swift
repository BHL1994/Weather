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
    
    func configureDailyCell(with forecastData: Forecast, _ index: Int){
        if index == 0 {
            dayLabel.text = "Today"
        } else {
            let day = forecastData.daily[index].dateTime
            dayLabel.text = convertTimeToDay(timestamp: day, forecastData: forecastData)
        }
        Task {
            do {
                let image = forecastData.daily[index].dailyWeather[0].icon
                let weatherimage = try await openWeatherController.fetchImage(icon: image)
                weatherIcon.image = weatherimage
            } catch {
                print("Error fetching Image")
            }
        }
        let temperatureLow = forecastData.daily[index].temp.tempMin
        temperatureLowLabel.text = "L: " + String(format: "%.0f", temperatureLow) + "°"
        let temperatureHigh = forecastData.daily[index].temp.tempMax
        temperatureHighLabel.text = "H: " + String(format: "%.0f", temperatureHigh) + "°"
    }
    
    func convertTimeToDay(timestamp: Int, forecastData: Forecast) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        let offset = forecastData.timezoneOffset
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.dateFormat = "E"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    

}
