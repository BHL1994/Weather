//
//  FeelsLikeTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class FeelsLikeTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(weather: Forecast){
        temperatureLabel.text =  String(format: "%.0f", weather.current.feelsLike) + "°"
    }

}
