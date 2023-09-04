//
//  GetLocationViewController.swift
//  WeatherApp
//
//  Created by Brien Lowe on 6/11/23.
//

import UIKit
import CoreLocation

class GetLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentWeatherData: CurrentWeather?
    var hourlyForecastData: HourlyForecast?
    
    let openWeatherController = OpenWeatherController()
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager: CLLocationManager?

            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
    

}

