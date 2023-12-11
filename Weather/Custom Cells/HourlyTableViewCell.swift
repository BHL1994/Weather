//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Brien Lowe on 11/5/23.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var forecastData: Forecast!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
    }
    
    func configureTableViewCell(with forecastData: Forecast){
        self.forecastData = forecastData
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
        cell.configureCollectionViewCell(with: forecastData, indexPath.row)
        
        return cell
    }
    
    
}
