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

    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationSymbol: UIImageView!
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTapped(_:)))
        locationGesture.numberOfTapsRequired = 1
        locationGesture.numberOfTouchesRequired = 1
        
        locationSymbol.addGestureRecognizer(locationGesture)
        locationSymbol.isUserInteractionEnabled = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    @objc func gestureTapped(_ gesture: UITapGestureRecognizer) {
        var locationManager: CLLocationManager?
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        if let location = locationManager?.location?.coordinate.latitude {
            latitude = location
        }

        if let location = locationManager?.location?.coordinate.longitude {
            longitude = location
        }
        
        locationManager?.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error -> Void in
            
            if error != nil {
                print("Error geocoding lcoation.")
                return
            }
            
            guard let placemark = placemarks?.first else{
                return
            }
            
            if let city = placemark.subLocality, let state = placemark.administrativeArea {
                self.locationLabel.text = "\(city), \(state)"
                
            }
        })
        
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

        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        destinationVC.currentWeatherData = currentWeatherData
        destinationVC.hourlyForecastData = hourlyForecastData
        

    }
    

}

