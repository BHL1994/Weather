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
    
    func weatherCellUpdate(weather: Forecast) {
        //cellNameLabel.text = weather.name
        cellWeatherLabel.text = String(format: "%.0f", weather.current.temp) + "°"
        cellLowLabel.text = "L: " + String(format: "%.0f", weather.daily[0].temp.tempMin) + "°"
        cellHighLabel.text = "H: " + String(format: "%.0f", weather.daily[0].temp.tempMax) + "°"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
