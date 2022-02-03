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
