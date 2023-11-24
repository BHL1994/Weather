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
    var placemark: CLPlacemark?
    let filter = GMSAutocompleteFilter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableDataSource()
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    func setupTableDataSource() {
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tableDataSource.tableCellBackgroundColor = .black
        filter.type = .geocode
        tableDataSource.autocompleteFilter = filter
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        tableDataSource.sourceTextHasChanged(searchController.searchBar.text)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherDetailViewController
        destinationVC.forecastData = GetLocationViewController.weatherList.last
    }
    
    func getName(place: GMSPlace) -> String {
        let city = place.addressComponents?.first(where: {$0.type == "administrative_area_level_1" })?.name
        let subLocality = place.addressComponents?.first(where: {$0.type == "sublocality_level_1" })?.name
        let country = place.addressComponents?.first(where: {$0.type == "country" })?.name

        if subLocality != place.name && subLocality != nil {
            return place.name! + ",\n \(subLocality!) "
        }
        
        if city != place.name && city != nil {
            return place.name! + ",\n \(city!) "
        }
        
        return place.name!
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
              var weatherInfo = try await openWeatherController.fetchForecast(latitude, longitude)
              weatherInfo.name = place.name
              weatherInfo.userLocation = false
              GetLocationViewController.weatherList.append(weatherInfo)
              performSegue(withIdentifier: "SearchSegue", sender: nil)
          } catch {
              print("Error fetching Weather Data")
          }
      }
  }

    

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
    print("Error: \(error.localizedDescription)")
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
    return true
  }
}
