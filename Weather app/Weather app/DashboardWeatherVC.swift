//
//  ViewController.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import UIKit
import MapKit

class DashboardWeatherVC: UIViewController {
    
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainTemp: UILabel!
    var requests = APIRequest()
    var currentWeather: CurrentWeather?
    var forecastWeather: ForecastWeather?
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserLocation()


    }
    
    func getUserLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else{
            print("Location service disabled");
        }
        
    }
    
    
    func getCurrentWeather(lat: Double, long: Double) {
        requests.getCurrentWeather(lat: lat, long: long) { [self] data, response, error in
            
            do {
                
                guard let mydata = data else { return }
                let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: mydata)
                self.currentWeather = jsonData
                
                DispatchQueue.main.async {
                    
                    guard let currentTemp = currentWeather?.main?.temp else { return }
                    guard let minTemp = currentWeather?.main?.tempMin else { return }
                    guard let maxTemp = currentWeather?.main?.tempMax else { return }
                    currentTemperature.text = "\(currentTemp)"
                    minTemperature.text = "\(minTemp)"
                    maxTemperature.text = "\(maxTemp)"
                    mainTemp.text = "\(currentTemp)"

                }
                
                
            } catch {
                print("Failed to decode data \(error.localizedDescription)")
            }
        }
    }
    
    func getForecasteWeather(lat: Double, long: Double) {
        
        requests.getForeCastWeather(lat: lat, long: long) { data, response, error in
            do {
                guard let mydata = data else { return }
                
                let jsonData = try JSONDecoder().decode(ForecastWeather.self, from: mydata)
                self.forecastWeather = jsonData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch {
                print("Failed to decode data \(error.localizedDescription)")
            }
        }
    }


}

extension DashboardWeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ForecastWeatherCell
        guard let temp = forecastWeather?.list?[indexPath.row].main.temp else { return cell }
        cell.dayOfTheWeek.text = "Monday"
        cell.weatherIcon.image = UIImage(named: "partlysunny")
        cell.temperature.text = "\(temp)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeather?.list?.count ?? 0
    }
}

extension DashboardWeatherVC: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
        
        self.latitude = locationValue.latitude
        self.longitude = locationValue.longitude
        
        getCurrentWeather(lat: locationValue.latitude, long: locationValue.longitude)
        
        getForecasteWeather(lat: locationValue.latitude, long: locationValue.longitude)

        
        
        
    }
}

