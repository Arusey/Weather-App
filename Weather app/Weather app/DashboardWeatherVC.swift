//
//  ViewController.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import UIKit

class DashboardWeatherVC: UIViewController {
    
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var requests = APIRequest()
    var currentWeather: CurrentWeather?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentWeather(lat: 35.0, long: 139.0)
    }
    
    
    func getCurrentWeather(lat: Double, long: Double) {
        requests.getCurrentWeather(lat: lat, long: long) { [self] data, response, error in
            
            do {
                
                guard let mydata = data else { return }
                let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: mydata)
                self.currentWeather = jsonData
                
                DispatchQueue.main.async {
                    currentTemperature.text = "\(currentWeather!.main.temp)"
                }
                
                
            } catch {
                print("Failed to decode data \(error.localizedDescription)")
            }
        }
    }


}

extension DashboardWeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

