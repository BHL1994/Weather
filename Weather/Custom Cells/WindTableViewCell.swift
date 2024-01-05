//
//  WindTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class WindTableViewCell: UITableViewCell {
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var gustLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    func configure(weather: Forecast){
        windLabel.text = String(format: "%.0f", weather.current.windSpeed) + " MPH Winds"
        if let windGust = weather.current.windGust{
            gustLabel.text = String(format: "%.0f", windGust) + " MPH Gusts"
        }else {
            gustLabel.text = "0 MPH Wind Gusts"
        }
        directionLabel.text = "Wind is heading " + degreeToDirection(degrees: weather.current.windDeg) + "."
    }
    
    //Converts the wind degree to a direction on compass
    func degreeToDirection(degrees: Int) -> String {
        var directions: [String] = ["North", "Northeast", "East", "Southeast", "South", "Southwest", "West", "Northwest"]
        let degrees = Double(degrees)
        let index = Int((degrees + 22.5) / 45) % 8
        
        return directions[index]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
