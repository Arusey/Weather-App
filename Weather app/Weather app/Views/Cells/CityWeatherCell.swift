//
//  CityWeatherCell.swift
//  Weather app
//
//  Created by Kevin Lagat on 05/02/2022.
//

import UIKit

class CityWeatherCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeOfDay: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    @IBOutlet weak var skyStatus: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension CityWeatherCell {
    
    func setupCell(_ details: Weather) {
        
        skyStatus.text = details.weatherDescription
    }
}
