//
//  APIRequests.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import Foundation


struct APIRequest {
    
    let apiKey = "26d7c2ca2aeec7f42fb39ffb1f66ab23"
    
    func getCurrentWeather(lat: Double, long: Double, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        
        task.resume()
        
    }
    
    
    
}
