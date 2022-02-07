//
//  AddLocationVC.swift
//  Weather app
//
//  Created by Kevin Lagat on 06/02/2022.
//

import UIKit
import GoogleMaps

class MapsVC: UIViewController {
    
    let favoritesModel = FavoritesModel()

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeatherForCities()
    }
    
    
    func fetchWeatherForCities() {
        let (weatherArr, error) = favoritesModel.fetchWeatherForCity()
        
        if let error = error {
            showError(error: error)
        } else {
            if let weatherArr = weatherArr, weatherArr.count > 0 {
                favoritesModel.favorites = weatherArr
                addPlaceMarks()

            }

        }
        
    }
    
    func addPlaceMarks() {
        
        for cityPins in favoritesModel.favorites {
            let latitude = cityPins.latitude
            let longitude = cityPins.longitude
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            marker.title = cityPins.city
            marker.map = mapView

        }
    }
    
}
