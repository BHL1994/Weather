//
//  GetLocationViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation

class GetLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {

    var currentWeatherData: CurrentWeather?
    var hourlyForecastData: HourlyForecast?
    let openWeatherController = OpenWeatherController()
    static var weatherList: [CurrentWeather] = [CurrentWeather]()
    static var hourlyForecastList: [HourlyForecast] = [HourlyForecast]()
    
    @IBOutlet var authorizeLocationButton: UIButton!
    @IBOutlet var allowAccessLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    var searchResultsTableViewController: SearchResultsTableViewController?
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        
        searchResultsSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if GetLocationViewController.weatherList.isEmpty {
//            tableView.isHidden = true
//        }

        if locationManager?.location == nil {
            tableViewSetup()
            tableView.topAnchor.constraint(equalTo: authorizeLocationButton.bottomAnchor, constant: 10).isActive = true
        }
        else {
            tableView.isHidden = false
            authorizeLocationButton.isHidden = true
            allowAccessLabel.isHidden = true
            tableViewSetup()
            tableView.topAnchor.constraint(equalTo: authorizeLocationButton.bottomAnchor, constant: 10).isActive = false
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            print("this")
        }
    }
    
    func searchResultsSetup(){
        searchResultsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsTableViewController") as? SearchResultsTableViewController
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.delegate = searchResultsTableViewController
        searchController.delegate = self
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a city, state or zip code"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = searchResultsTableViewController
        self.searchController = searchController
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
                    GetLocationViewController.weatherList.append(weatherInfo)
                    let hourlyInfo = try await openWeatherController.fetchHourlyForecast(latitude, longitude)
                    GetLocationViewController.hourlyForecastList.append(hourlyInfo)
                    performSegue(withIdentifier: "PermissionSegue", sender: nil)
                    print(GetLocationViewController.weatherList.count)
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
    
    @IBAction func unwindToGetLocationViewController(unwindSegue: UIStoryboardSegue) {
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        if segue.identifier == "PermissionSegue"{
            destinationVC.currentWeatherData = GetLocationViewController.weatherList.last
            destinationVC.hourlyForecastData = GetLocationViewController.hourlyForecastList.last
        }
        else{
            let section = (sender as! IndexPath).section
            destinationVC.currentWeatherData = GetLocationViewController.weatherList[section]
            destinationVC.hourlyForecastData = GetLocationViewController.hourlyForecastList[section]
        }
        
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
        return GetLocationViewController.weatherList.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CellSegue", sender: indexPath)
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
        
        let weather = GetLocationViewController.weatherList[indexPath.section]
        cell.weatherCellUpdate(weather: weather)
        
        return cell
    }

}
