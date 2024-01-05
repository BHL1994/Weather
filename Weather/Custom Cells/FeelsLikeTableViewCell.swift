//
//  FeelsLikeTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class FeelsLikeTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(weather: Forecast){
        temperatureLabel.text =  String(format: "%.0f", weather.current.feelsLike) + "° F"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
