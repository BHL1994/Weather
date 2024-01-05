//
//  VisibilityTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 12/27/23.
//

import UIKit

class VisibilityTableViewCell: UITableViewCell {

    @IBOutlet weak var visibilityLabel: UILabel!
    
    func configure(weather: Forecast){
        let visibility = weather.current.visibility/1609
        visibilityLabel.text = "\(visibility) Miles"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
