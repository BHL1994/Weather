//
//  SearchResultsTableViewController.swift
//  Weather
//
//  Created by Brien Lowe on 10/2/23.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchItems = ["Brien", "Brian", "Georgia", "Alabama", "Idaho", "Las Vegas", "Maine", "Texas"]
    
    var filteredItems = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = filteredItems[indexPath.row]
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredItems.removeAll()
        if let text = searchController.searchBar.text {
            for string in searchItems {
                if string.contains(text) {
                    filteredItems.append(string)
                }
            }
        }
        print(filteredItems)
        tableView.reloadData()
    }
}

