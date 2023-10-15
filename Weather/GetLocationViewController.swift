//
//  GetLocationViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation
import GooglePlaces

class GetLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    //Google API Key - AIzaSyBZcF7t7gmHDuAFtah2gf18aWBNnmPh_Zk
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=909&East&29th&key=AIzaSyBZcF7t7gmHDuAFtah2gf18aWBNnmPh_Zk
    
    
    var currentWeatherData: CurrentWeather?
    var hourlyForecastData: HourlyForecast?
    let openWeatherController = OpenWeatherController()
    var weatherList: [CurrentWeather] = [CurrentWeather]()
    var hourlyForecastList: [HourlyForecast] = [HourlyForecast]()
    
    @IBOutlet var authorizeLocationButton: UIButton!
    @IBOutlet var allowAccessLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    var searchResultsTableViewController: SearchResultsTableViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        
        searchResultsSetup()
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
    
    func searchResultsSetup(){
        searchResultsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsTableViewController") as! SearchResultsTableViewController
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.delegate = self
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a city, state or zip code"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = searchResultsTableViewController
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
                    //currentWeatherData = weatherInfo
                    weatherList.append(weatherInfo)
                } catch {
                    print("Error fetching Weather Data")
                }
            }
            Task {
                do {
                    let weatherInfo = try await openWeatherController.fetchHourlyForecast(latitude, longitude)
                    //hourlyForecastData = weatherInfo
                    hourlyForecastList.append(weatherInfo)
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
        //destinationVC.currentWeatherData = currentWeatherData
        //destinationVC.hourlyForecastData = hourlyForecastData
        destinationVC.currentWeatherData = weatherList[0]
        destinationVC.hourlyForecastData = hourlyForecastList[0]
        //print(tableView.indexPathForSelectedRow?.row)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PermissionSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            weatherList.remove(at: indexPath.section)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.layer.cornerRadius = 20
        
        let weather = weatherList[indexPath.section]
        cell.weatherCellUpdate(weather: weather)
        
        return cell
    }

}
