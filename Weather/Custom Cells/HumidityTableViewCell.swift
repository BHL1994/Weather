//
//  HumidityTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class HumidityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var dewPointLabel: UILabel!
    
    func configure(weather: Forecast){
        humidityLabel.text = String(weather.current.humidity) + "%"
        dewPointLabel.text = "The dew point is " + String(format: "%.0f", weather.current.dewPoint) + "° right now."
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
