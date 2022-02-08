//
//  FavoritesModel.swift
//  Weather app
//
//  Created by Kevin Lagat on 06/02/2022.
//

import Foundation
import CoreData

public class FavoritesModel: NSManagedObject {
    
    // Variables
    static let shared = FavoritesModel()
    let manager = CoreDataManager(modelName: "CoreWeather")
    var favorites: [Favorites] = []

        // Add city to favorites
    func addToFavorites(cityWeather: CityWeather) {
        let favoritesObject = Favorites(context: manager.managedObjectContext)
        
        for favorite in favorites {
            print(favorite)
            if favorite.city == cityWeather.name {
                return
            }

        }
        
        favoritesObject.temp = String(format: "%.0f", cityWeather.main.temp - 273.15) + "°C"
        favoritesObject.city = cityWeather.name
        favoritesObject.maxtemp = String(format: "%.0f", cityWeather.main.tempMax - 273.15) + "°C"
        favoritesObject.mintemp = String(format: "%.0f", cityWeather.main.tempMin - 273.15) + "°C"
        favoritesObject.skystatus = cityWeather.weather.first?.weatherDescription
        favoritesObject.latitude = cityWeather.coord.lat
        favoritesObject.longitude = cityWeather.coord.lon
        

        self.favorites.insert(favoritesObject, at: 0)

        
        //Save to persistent store
        do {
            try manager.managedObjectContext.save()
            
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // Fetch favorites: Core data
    func fetchWeatherForCity() -> ([Favorites]?, Error?) {
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do {
            let favorites = try manager.managedObjectContext.fetch(fetchRequest)

            return (favorites, nil)
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return (nil, error)
        }
    }
    
    //
    func deleteCityWeather(favorite: Favorites) {
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do {
            manager.managedObjectContext.delete(favorite)
            do {
                try manager.managedObjectContext.save()
                
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        
        
    }
}

