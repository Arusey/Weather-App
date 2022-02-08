//
//  ViewController.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import UIKit
import MapKit

class DashboardWeatherVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var mainTemp: UILabel!
    @IBOutlet weak var midStackView: UIStackView!
    
    // MARK: - Instance Properties

    var requests = APIRequest()
    var currentWeather: CurrentWeather?
    var forecastWeather: ForecastWeather?
    var cityWeather: CityWeather?
    let locationManager = CLLocationManager()
    let favoritesModel = FavoritesModel()
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.title = "Dashboard"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserLocation()
    }
    
    
    // MARK: - Instance Methods

    func getWeatherStatus(weatherStatus: Weather) {
        
        switch weatherStatus.weatherStatus {
        case .clouds:
            self.view.backgroundColor = UIColor.cloudyColor
            self.tableView.backgroundColor = UIColor.cloudyColor
            self.weatherImage.image = UIImage(named: "sea_cloudy")
            self.weatherStatus.text = "Cloudy"
            self.midStackView.layer.backgroundColor = UIColor.cloudyColor.cgColor
        case .rain:
            self.view.backgroundColor = UIColor.rainyColor
            self.tableView.backgroundColor = UIColor.rainyColor
            self.weatherImage.image = UIImage(named: "sea_rainy")
            self.weatherStatus.text = "Rainy"
            self.midStackView.layer.backgroundColor = UIColor.rainyColor.cgColor
            
        case .sun:
            self.view.backgroundColor = UIColor.sunnyColor
            self.tableView.backgroundColor = UIColor.sunnyColor
            self.weatherImage.image = UIImage(named: "sea_sunnypng")
            self.weatherStatus.text = "Sunny"
            self.midStackView.layer.backgroundColor = UIColor.sunnyColor.cgColor
            
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
                    guard let weather = currentWeather?.weather?.first else { return }
                    guard let currentTemp = currentWeather?.main?.temp else { return }
                    guard let minTemp = currentWeather?.main?.tempMin else { return }
                    guard let maxTemp = currentWeather?.main?.tempMax else { return }
                    currentTemperature.text = String(format: "%.0f", currentTemp - 273.15) + "°"
                    minTemperature.text = String(format: "%.0f", minTemp - 273.15) + "°"
                    maxTemperature.text = String(format: "%.0f", maxTemp - 273.15) + "°"
                    mainTemp.text = String(format: "%.0f", currentTemp - 273.15) + "°"
                    getWeatherStatus(weatherStatus: weather)
                    self.navigationItem.title = currentWeather?.name
                }
            } catch {
                print("Failed to decode data \(String(describing: error))")
                DispatchQueue.main.async {
                    WaitingOverlays.removeAllBlockingOverlays()
                }
            }
        }
    }

    
    // Get forecast weather
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
                print("Failed to decode data \(String(describing: error))")
                DispatchQueue.main.async {
                    WaitingOverlays.removeAllBlockingOverlays()
                }
            }
        }
    }
    
    
}

// MARK: - UITableView DataSource

extension DashboardWeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ForecastWeatherCell
        guard let weatherStat = forecastWeather?.list else { return cell }
        guard let weather = forecastWeather?.list?[indexPath.row].weather.first else { return cell }
        
        switch weather.weatherStatus {
        case .sun:
            cell.weatherIcon.image = UIImage(named: "clear")
            cell.contentView.layer.backgroundColor = UIColor.sunnyColor.cgColor
        case .clouds:
            cell.weatherIcon.image = UIImage(named: "partlysunny")
            cell.contentView.layer.backgroundColor = UIColor.cloudyColor.cgColor
        case .rain:
            cell.contentView.layer.backgroundColor = UIColor.rainyColor.cgColor
            cell.weatherIcon.image = UIImage(named: "rain")
        }
        
        getWeatherStatus(weatherStatus: weather)
        cell.setupCell(weatherStat[indexPath.row], indexPathRow: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - LocationManager Delegate

extension DashboardWeatherVC: CLLocationManagerDelegate {
    // Get Coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getCurrentWeather(lat: locationValue.latitude, long: locationValue.longitude)
        getForecasteWeather(lat: locationValue.latitude, long: locationValue.longitude)
    }
}

