//
//  ForecastWeatherCell.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import UIKit

class ForecastWeatherCell: UITableViewCell {
    
    @IBOutlet weak var dayOfTheWeek: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension ForecastWeatherCell {
    
    
    func setupCell(_ details: List, indexPathRow: Int) {
        dayOfTheWeek.text = Date().getNextDate(current: indexPathRow)
        temperature.text = String(format: "%.0f", details.main.temp - 273.15) + "°C"
    }
}
