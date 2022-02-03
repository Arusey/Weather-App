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
    
    
    func getWeatherStatus() {
        
        guard let currentStatus = currentWeather?.weather?[0].main else {
            return
        }

        if currentStatus == "Clouds" {
            weatherImage.image = UIImage(named: "sea_cloudy")
            
            
        } else if currentStatus == "Clear" {
            weatherImage.image = UIImage(named: "sea_sunnypng")
        } else {
            weatherImage.image = UIImage(named: "sea_rainy")
        }
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
        WaitingOverlays.showBlockingWaitOverlay()

        requests.getCurrentWeather(lat: lat, long: long) { [self] data, response, error in
            
            do {
                
                guard let mydata = data else { return }
                let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: mydata)
                self.currentWeather = jsonData
                
                DispatchQueue.main.async {
                    
                    guard let currentTemp = currentWeather?.main?.temp else { return }
                    guard let minTemp = currentWeather?.main?.tempMin else { return }
                    guard let maxTemp = currentWeather?.main?.tempMax else { return }
                    currentTemperature.text = String(format: "%.0f", currentTemp - 273.15) + "°"
                    minTemperature.text = String(format: "%.0f", minTemp - 273.15) + "°"
                    maxTemperature.text = String(format: "%.0f", maxTemp - 273.15) + "°"
                    mainTemp.text = String(format: "%.0f", currentTemp - 273.15) + "°"
                    getWeatherStatus()
//                    WaitingOverlays.removeAllBlockingOverlays()

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
                    WaitingOverlays.removeAllBlockingOverlays()

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
        guard let weatherStat = forecastWeather?.list?[indexPath.row].weather[0].main else { return cell }
        guard let weatherDescription = forecastWeather?.list?[indexPath.row].weather[0].weatherDescription else { return cell }
        cell.dayOfTheWeek.text = "Monday"
        cell.weatherIcon.image = UIImage(named: "partlysunny")
        cell.temperature.text = String(format: "%.0f", temp - 273.15) + "°"

        switch weatherStat {
        case .clouds:
            cell.weatherIcon.image = UIImage(named: "partlysunny")
        case .rain:
            cell.weatherIcon.image = UIImage(named: "rain")
        case .sun:
            cell.weatherIcon.image = UIImage(named: "clear")
        default:
            cell.weatherIcon.image = UIImage(named: "clear")
        }
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
        getCurrentWeather(lat: locationValue.latitude, long: locationValue.longitude)
        getForecasteWeather(lat: locationValue.latitude, long: locationValue.longitude)
    }
}

