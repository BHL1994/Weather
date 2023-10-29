//
//  SearchResultsTableViewController.swift
//  Weather
//
//  Created by Brien Lowe on 10/2/23.
//

import UIKit
import GooglePlaces

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    let openWeatherController = OpenWeatherController()
    let getLocationViewController = GetLocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableDataSource.tableCellBackgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        tableDataSource.sourceTextHasChanged(searchController.searchBar.text)
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        destinationVC.currentWeatherData = GetLocationViewController.weatherList.last
        destinationVC.hourlyForecastData = GetLocationViewController.hourlyForecastList.last
    }
    
}

extension SearchResultsTableViewController: GMSAutocompleteTableDataSourceDelegate {
  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    tableView.reloadData()
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
      let latitude = place.coordinate.latitude
      let longitude = place.coordinate.longitude
      Task {
          do {
              let weatherInfo = try await openWeatherController.fetchCurrentWeather(latitude,longitude)
              GetLocationViewController.weatherList.append(weatherInfo)
              let hourlyInfo = try await openWeatherController.fetchHourlyForecast(latitude, longitude)
              GetLocationViewController.hourlyForecastList.append(hourlyInfo)
              performSegue(withIdentifier: "SearchSegue", sender: nil)
          } catch {
              print("Error fetching Weather Data")
          }
      }
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
    // Handle the error.
    print("Error: \(error.localizedDescription)")
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
    return true
  }
}
