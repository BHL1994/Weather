//
//  GetLocationViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation

class GetLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var currentWeatherData: CurrentWeather?
    var hourlyForecastData: HourlyForecast?
    let openWeatherController = OpenWeatherController()
    var weatherList: [CurrentWeather] = [CurrentWeather]()
    
    
    @IBOutlet var authorizeLocationButton: UIButton!
    @IBOutlet var allowAccessLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?

    let searchController = UISearchController(searchResultsController: nil)
    
    let names: [String] = ["Brien", "Joe", "Josh"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.title = "Location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if weatherList.isEmpty {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
            authorizeLocationButton.isHidden = true
            allowAccessLabel.isHidden = true
            tableViewSetup()
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            break
        case .restricted:
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager?.requestLocation()
            if let location = locationManager?.location?.coordinate.latitude {
                latitude = location
            }
            if let location = locationManager?.location?.coordinate.longitude {
                longitude = location
            }
            Task {
                do {
                    let weatherInfo = try await openWeatherController.fetchCurrentWeather(latitude,longitude)
                    currentWeatherData = weatherInfo
                    weatherList.append(currentWeatherData!)
                } catch {
                    print("Error fetching Weather Data")
                }
            }
            Task {
                do {
                    let weatherInfo = try await openWeatherController.fetchHourlyForecast(latitude, longitude)
                    hourlyForecastData = weatherInfo
                } catch {
                    print("Error fetching Weather Data")
                }
            }
        default:
            break
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
            
        if locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse {
            performSegue(withIdentifier: "PermissionSegue", sender: nil)
        }
    }
    
    @IBAction func unwindToGetLocationViewController(unwindSegue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        destinationVC.currentWeatherData = currentWeatherData
        destinationVC.hourlyForecastData = hourlyForecastData
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

           let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
           view.backgroundColor = .clear

           return view
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherList.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.layer.cornerRadius = 20
        
        let weather = weatherList[indexPath.section]
        cell.weatherCellUpdate(weather: weather)
        
        return cell
    }

}

