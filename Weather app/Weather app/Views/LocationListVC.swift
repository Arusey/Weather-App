//
//  AddLocationVC.swift
//  Weather app
//
//  Created by Kevin Lagat on 05/02/2022.
//

import UIKit

class LocationListVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var requests = APIRequest()
    var cityWeather: CityWeather?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureSearch()

        // Do any additional setup after loading the view.
    }
    
    
    func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Enter city to search...;"
        navigationItem.searchController = search
    }
    
    
}



extension LocationListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let city = searchController.searchBar.text else { return }
        print(city)
        requests.getWeatherByCity(cityName: city) { data, response, error in
            
            do {
                guard let mydata = data else { return }
                
                let jsonData = try JSONDecoder().decode(CityWeather.self, from: mydata)
                self.cityWeather = jsonData
                print(self.cityWeather)
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
            } catch {
                print("Failed to decode data \(String(describing: error))")
            }
            
        }
        
    }
    
}

extension LocationListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityWeatherCell
        
        guard let cityDetails = cityWeather else { return cell }
        cell.minTemp.text = String(format: "%.0f", cityDetails.main.tempMin - 273.15) + "°C"
        cell.maxTemp.text = String(format: "%.0f", cityDetails.main.tempMax - 273.15) + "°C"
        cell.cityTemperature.text = String(format: "%.0f", cityDetails.main.temp - 273.15) + "°C"
        cell.cityName.text = cityDetails.name
//        cell.setupCell(cityDetails.weather.first ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

extension LocationListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
