//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation
import QuartzCore

class WeatherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    var forecastData: Forecast!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    let openWeatherController = OpenWeatherController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowRadius = 5
        tableView.layer.shadowOffset = .init(width: 0, height: 5)

        updateUI()
    }
    
    //Updates the data on the weather detail page
    func updateUI(){
        temperatureLabel.text = String(format: "%.0f", forecastData.current.temp) + "°"
        locationLabel.text = forecastData.name
        temperatureDescriptionLabel.text = forecastData.current.weather[0].description
        temperatureHighLabel.text = "H: " + String(format: "%.0f", forecastData.daily[0].temp.tempMax) + "°"
        temperatureLowLabel.text = "L: " + String(format: "%.0f", forecastData.daily[0].temp.tempMin) + "°"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return forecastData.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableCell", for: indexPath) as! HourlyTableViewCell
            cell.configureTableViewCell(with: forecastData)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableCell", for: indexPath) as! DailyTableViewCell
        cell.configureDailyCell(with: forecastData, indexPath.row)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Hourly Forecast"
//        }
//        else if section == 1 {
//            return "8-Day Forecast"
//        }
//        return nil
//    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        }
        return 150
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 10
    }
        
}
