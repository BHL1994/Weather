//
//  HeaderTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/28/23.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(index: Int, currentTime: Int, sunrise: Int, sunset: Int){
        switch index {
        case 0:
            headerLabel.text = "Hourly Forecast"
        case 1:
            headerLabel.text = "8-Day Forecast"
        case 2:
            if currentTime > sunrise && currentTime > sunset {
                headerLabel.text = "Sunrise"
            }
            else{
                headerLabel.text = "Sunset"
            }
        case 3:
            headerLabel.text = "Feels Like"
        case 4:
            headerLabel.text = "Visibility"
        case 5:
            headerLabel.text = "Wind"
        case 6:
            headerLabel.text = "Humidity"
        default:
            "nil"
        }
    }
    

}
