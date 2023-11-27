//
//  GetLocationViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation

class GetLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {

    var forecastData: Forecast?
    let openWeatherController = OpenWeatherController()
    
    var userLocation: Bool = false
    
    static var weatherList: [Forecast] = [Forecast]() {
        didSet {
            Forecast.saveForecasts(forecast: weatherList)
        }
    }
        
    @IBOutlet var authorizeLocationButton: UIButton!
    @IBOutlet var allowAccessLabel: UILabel!

    var placemark: CLPlacemark?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    let geocoder = CLGeocoder()
    
    var searchResultsTableViewController: SearchResultsTableViewController?
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        loadingView.isHidden = true
        searchResultsSetup()
        tableViewSetup()
        if let forecasts = Forecast.loadForecasts() {
            GetLocationViewController.weatherList = forecasts
        }
        getLocation()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appIsActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        updateCells()
    }
    
    @objc func appIsActive(){
        getLocation()
    }
    
    func getLocation(){
        locationManager = CLLocationManager()
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.delegate = self
        case .authorizedWhenInUse:
            if GetLocationViewController.weatherList.first?.name == "My Location" {
                break
            }
            else {
                locationManager?.delegate = self
            }
        case .authorizedAlways:
            if GetLocationViewController.weatherList.first?.name == "My Location" {
                break
            }
            else {
                locationManager?.delegate = self
            }
        case .denied:
            if GetLocationViewController.weatherList.first?.name == "My Location" {
                GetLocationViewController.weatherList.remove(at: 0)
            }
        default:
            break
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        updateCells()
        tableView.reloadData()
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
    
    func getName(latitude: Double, longitude: Double){
        let location = CLLocation(latitude: latitude, longitude: longitude)

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error{
                print(error)
            }
            if let placemark = placemarks?.first {
                self.placemark = placemark
            }
        }
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
                    if(GetLocationViewController.weatherList.first?.name == "My Location"){
                        GetLocationViewController.weatherList.remove(at: 0)
                    }
                    GetLocationViewController.weatherList.insert(weatherInfo, at: 0)
                    GetLocationViewController.weatherList[0].name = "My Location"
                    performSegue(withIdentifier: "PermissionSegue", sender: nil)
                    locationManager?.stopUpdatingLocation()
                } catch {
                    print("Error fetching Weather Data")
                    hideActivityIndicator()
                }
            }
        default:
            break
        }
        authorizeLocationButton.isEnabled = true
    }
    
    func updateCells(){
        for (index) in GetLocationViewController.weatherList.indices {
            let latitude = GetLocationViewController.weatherList[index].latitude
            let longitude = GetLocationViewController.weatherList[index].longitude
            Task {
                do {
                    let weatherInfo = try await openWeatherController.fetchForecast(latitude, longitude)
                    GetLocationViewController.weatherList[index].current.dateTime = weatherInfo.current.dateTime
                    GetLocationViewController.weatherList[index].current.temp = weatherInfo.current.temp
                    GetLocationViewController.weatherList[index].daily[0].temp.tempMax = weatherInfo.daily[0].temp.tempMax
                    GetLocationViewController.weatherList[index].daily[0].temp.tempMin = weatherInfo.daily[0].temp.tempMin
                    GetLocationViewController.weatherList[index].current.dateTime = weatherInfo.current.dateTime
                } catch {
                    print("Error fetching Weather Data")
                }
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
    }
    
    @IBAction func unwindToGetLocationViewController(unwindSegue: UIStoryboardSegue) {
        searchController.isActive = false
        viewDidLoad()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 0 && GetLocationViewController.weatherList.first?.name == "My Location" {
            userLocation = false
            locationManager = nil
            GetLocationViewController.weatherList.remove(at: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
        else {
            GetLocationViewController.weatherList.remove(at: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && GetLocationViewController.weatherList.first?.name == "My Location" {
            return false;
        }
        
        return true;
    }
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && GetLocationViewController.weatherList[0].name == "My Location" {
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
