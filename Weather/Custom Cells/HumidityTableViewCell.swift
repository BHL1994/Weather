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
        dewPointLabel.text = "The current dew point is " + String(format: "%.0f", weather.current.dewPoint) + "° right now."
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
