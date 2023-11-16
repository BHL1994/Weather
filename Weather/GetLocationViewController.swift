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
    var forecastData: Forecast?
    let openWeatherController = OpenWeatherController()
    static var weatherList: [Forecast] = [Forecast]()
    
    var userLocation: Forecast?
    
    @IBOutlet var authorizeLocationButton: UIButton!
    @IBOutlet var allowAccessLabel: UILabel!

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    var searchResultsTableViewController: SearchResultsTableViewController?
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        loadingView.isHidden = true
        searchResultsSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userLocation == nil {
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
        }
    }
    
    func searchResultsSetup(){
        searchResultsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsTableViewController") as? SearchResultsTableViewController
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.delegate = searchResultsTableViewController
        searchController.delegate = self
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = true
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
            showActivityIndicator()
            locationManager?.requestLocation()
            sleep(2)
            if let location = locationManager?.location?.coordinate.latitude {
                latitude = location
            }
            if let location = locationManager?.location?.coordinate.longitude {
                longitude = location
            }
            Task {
                do {
                    let weatherInfo = try await openWeatherController.fetchForecast(latitude, longitude)
                    userLocation = weatherInfo
                    if let location = userLocation{
                        GetLocationViewController.weatherList.insert(location, at: 0)
                    }
                    performSegue(withIdentifier: "PermissionSegue", sender: nil)
                    locationManager?.stopUpdatingLocation()
                } catch {
                    print("Error fetching Weather Data")
                }
            }
        default:
            break
        }
        authorizeLocationButton.isEnabled = true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        authorizeLocationButton.isEnabled = false
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    @IBAction func unwindToGetLocationViewController(unwindSegue: UIStoryboardSegue) {
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        if segue.identifier == "PermissionSegue"{
            destinationVC.forecastData = GetLocationViewController.weatherList[0]
        }
        else{
            let section = (sender as! IndexPath).section
            destinationVC.forecastData = GetLocationViewController.weatherList[section]
        }
        hideActivityIndicator()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userLocation != nil && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! WeatherTableViewCell
            cell.layer.cornerRadius = 20
            
            let weather = GetLocationViewController.weatherList[indexPath.section]
            cell.weatherCellUpdate(weather: weather)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.layer.cornerRadius = 20
        
        let weather = GetLocationViewController.weatherList[indexPath.section]
        cell.weatherCellUpdate(weather: weather)
        
        return cell
    }
    
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        loadingView.isHidden = false
        loadingView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }

}
