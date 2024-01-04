//
//  SunriseTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class SunriseTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(weather: Forecast){
        let currentTime = weather.current.dateTime
        let sunrise = weather.current.sunrise
        let sunset = weather.current.sunset
        
        //If time is past sunrise and sunset, ex. end of the night,
        //show the sunrise and sunset time for tomorrow
        if currentTime > sunrise && currentTime > sunset {
            var time = weather.daily[1].sunrise
            timeLabel.text = convertTime(timestamp: time, forecastData: weather)
            time = weather.daily[1].sunset
            descriptionLabel.text = "Sunset: " + convertTime(timestamp: time, forecastData: weather)
        }
        //otherwise if it is passed sunrise but still not sunset
        //show the sunset time for today and sunrise for tomorrow
        else if currentTime > sunrise && currentTime < sunset {
            timeLabel.text = convertTime(timestamp: sunset, forecastData: weather)
            var time = weather.daily[1].sunrise
            descriptionLabel.text = "Sunrise: " + convertTime(timestamp: time, forecastData: weather)
        }
        //otherwise if sunrise and sunset have not passed yet
        //then show the sunrise and sunset for today
        else if currentTime < sunrise && currentTime < sunset {
            timeLabel.text = convertTime(timestamp: sunrise, forecastData: weather)
            descriptionLabel.text = "Sunset: " + convertTime(timestamp: sunset, forecastData: weather)
        }
    }
    
    func convertTime(timestamp: Int, forecastData: Forecast) -> String {
        let time = Double(timestamp)
        
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        let offset = forecastData.timezoneOffset
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.dateFormat = "h:mm a"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
