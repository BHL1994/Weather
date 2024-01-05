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
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let openWeatherController = OpenWeatherController()
    
    var forecastData: Forecast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowRadius = 5
        tableView.layer.shadowOffset = .init(width: 0, height: 5)
        updateUI(forecast: forecastData)
    }
    
    //Updates the data on the weather detail page
    func updateUI(forecast: Forecast){
        temperatureLabel.text = String(format: "%.0f", forecastData.current.temp) + "°"
        locationLabel.text = forecastData.name
        temperatureDescriptionLabel.text = forecastData.current.weather[0].description
        temperatureHighLabel.text = "H: " + String(format: "%.0f", forecastData.daily[0].temp.tempMax) + "°"
        temperatureLowLabel.text = "L: " + String(format: "%.0f", forecastData.daily[0].temp.tempMin) + "°"
        switch forecast.current.weather[0].main {
        case "Clear":
            if forecast.current.dateTime > forecast.current.sunset {
                backgroundImageView.image = UIImage(named: "Clear Sky Night")
            }
            else {
                backgroundImageView.image = UIImage(named: "Clear Sky Day")
            }
        case "Clouds":
            backgroundImageView.image = UIImage(named: "Cloudy")
        case "Rain", "Mist":
            backgroundImageView.image = UIImage(named: "Rain")
        case "Thunderstorm":
            backgroundImageView.image = UIImage(named: "Thunderstorm")
        case "Snow":
            backgroundImageView.image = UIImage(named: "Snow")
        default:
            backgroundImageView.image = UIImage(named: "sunny2")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return forecastData.daily.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        }
        else if indexPath.section == 2 || indexPath.section == 5 {
            return 125
        }
        else if indexPath.section == 3 || indexPath.section == 4{
            return 110
        }
        
        return 150
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 70
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableViewCell
        cell.configure(index: section, currentTime: forecastData.current.dateTime, sunrise: forecastData.current.sunrise, sunset: forecastData.current.sunset)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableCell", for: indexPath) as! HourlyTableViewCell
            cell.configureTableViewCell(with: forecastData)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableCell", for: indexPath) as! DailyTableViewCell
            cell.configureDailyCell(with: forecastData, indexPath.row)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SunriseCell", for: indexPath) as! SunriseTableViewCell
            cell.configure(weather: forecastData)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeelsLikeCell", for: indexPath) as! FeelsLikeTableViewCell
            cell.configure(weather: forecastData)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisibilityCell", for: indexPath) as! VisibilityTableViewCell
            cell.configure(weather: forecastData)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HumidityCell", for: indexPath) as! HumidityTableViewCell
            cell.configure(weather: forecastData)
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "WindCell", for: indexPath) as! WindTableViewCell
        cell.configure(weather: forecastData)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return cell
    }
}
