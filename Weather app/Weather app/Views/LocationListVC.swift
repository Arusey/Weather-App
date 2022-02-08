//
//  AddLocationVC.swift
//  Weather app
//
//  Created by Kevin Lagat on 05/02/2022.
//

import UIKit
import GooglePlaces


class LocationListVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    let favoritesModel = FavoritesModel()
    var requests = APIRequest()
    var cityWeather: CityWeather?
    var currentWeather: CurrentWeather?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearch()

        fetchWeatherForCities()
    }
    
    // Fetch weather for cities
    func fetchWeatherForCities() {
        let (weatherArr, error) = favoritesModel.fetchWeatherForCity()
        
        if let error = error {
            showError(error: error)
        } else {
            if let weatherArr = weatherArr, weatherArr.count > 0 {
                favoritesModel.favorites = weatherArr
                tableView.reloadData()
            }

        }
        
    }
    
    // Configure  search cities
    func configureSearch() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true

        searchController?.hidesNavigationBarDuringPresentation = false

        
    }
    
    
}

extension LocationListVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
           print("Error: ", error.localizedDescription)
    }
    
    
    // Get city name and make API call
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false

        guard let cityName = place.name else { return }
        
        let name = cityName.replacingOccurrences(of: " ", with: "+")
        
        requests.getWeatherByCity(cityName: name) { [self] data, response, error in
            
            do {
                guard let mydata = data else { return }
                
                let jsonData = try JSONDecoder().decode(CityWeather.self, from: mydata)
                self.cityWeather = jsonData

                
                guard let cityDetails = cityWeather else { return }
                
                favoritesModel.addToFavorites(cityWeather: cityDetails)

                DispatchQueue.main.async {

                    self.tableView.reloadData()

                }
            } catch {
                print("Failed to decode data \(String(describing: error))")
            }
            
        }
        
        
        
    }
    
    // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
}



extension LocationListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityWeatherCell
        
        cell.minTemp.text = favoritesModel.favorites[indexPath.row].mintemp
        cell.maxTemp.text = favoritesModel.favorites[indexPath.row].maxtemp
        cell.cityTemperature.text = favoritesModel.favorites[indexPath.row].temp
        cell.cityName.text = favoritesModel.favorites[indexPath.row].city
        cell.skyStatus.text = favoritesModel.favorites[indexPath.row].skystatus
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return favoritesModel.favorites.count
    }
    
}

extension LocationListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let cityWeather = favoritesModel.favorites[indexPath.row]
            favoritesModel.favorites.remove(at: indexPath.row)
            favoritesModel.deleteCityWeather(favorite: cityWeather)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }

    

}
