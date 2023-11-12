//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation

class WeatherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var currentWeatherData: CurrentWeather!
    var hourlyForecastData: HourlyForecast!

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateUI()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return hourlyForecastData.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableCell", for: indexPath) as! HourlyTableViewCell
            cell.configureTableViewCell(with: hourlyForecastData)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableCell", for: indexPath) as! DailyTableViewCell
        cell.configureDailyCell(with: hourlyForecastData, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Hourly Forecast"
        }
        else if section == 1{
            return "7-Day Forecast"
        }
        return nil
    }

    
    func updateUI(){
        temperatureLabel.text = String(format: "%.0f", currentWeatherData.main.temp) + "°"
        locationLabel.text = currentWeatherData.name
        temperatureDescriptionLabel.text = currentWeatherData.weather[0].description
        temperatureHighLabel.text = "H: " + String(format: "%.0f", currentWeatherData.main.tempMax) + "°"
        temperatureLowLabel.text = "L: " + String(format: "%.0f", currentWeatherData.main.tempMin) + "°"
    }
    


    
     
    
}
