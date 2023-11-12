//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 11/5/23.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var hourlyForecastData: HourlyForecast!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    func configureTableViewCell(with hourlyForecastData: HourlyForecast){
        self.hourlyForecastData = hourlyForecastData
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionCell", for: indexPath) as! HourlyCollectionViewCell
        cell.configureCollectionViewCell(with: hourlyForecastData, indexPath.row)
        
        return cell
    }
    
}
