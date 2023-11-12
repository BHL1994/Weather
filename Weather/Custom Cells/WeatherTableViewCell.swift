//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 9/10/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellWeatherLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    @IBOutlet weak var cellLowLabel: UILabel!
    @IBOutlet weak var cellHighLabel: UILabel!
    
    func weatherCellUpdate(weather: CurrentWeather) {
        cellNameLabel.text = weather.name
        cellWeatherLabel.text = String(format: "%.0f", weather.main.temp) + "°"
        cellLowLabel.text = "L: " + String(format: "%.0f", weather.main.tempMin) + "°"
        cellHighLabel.text = "H: " + String(format: "%.0f", weather.main.tempMax) + "°"
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
