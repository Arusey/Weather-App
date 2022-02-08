//
//  AddLocationVC.swift
//  Weather app
//
//  Created by Kevin Lagat on 06/02/2022.
//

import UIKit
import MapKit

class MapsVC: UIViewController {
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let favoritesModel = FavoritesModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeatherForCities()
    }
    
    // MARK: - Methods

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
    // placemarks for saved cities
    func addPlaceMarks() {
        
        for cityPins in favoritesModel.favorites {
            let latitude = cityPins.latitude
            let longitude = cityPins.longitude
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = position
            annotation.title = cityPins.city
            self.mapView.addAnnotation(annotation)
            

        }
    }
    
}
