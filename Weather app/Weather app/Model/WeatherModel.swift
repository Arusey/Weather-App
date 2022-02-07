//
//  WeatherModel.swift
//  Weather app
//
//  Created by Kevin Lagat on 02/02/2022.
//

import Foundation

enum WeatherStatus {
    case cloudy
    case sunny
    case rainy
}

struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    enum CurrentWeatherStatus: String, Codable {
        case clouds = "Clouds"
        case rain = "Rain"
        case sun = "Sun"
    }
    
    var weatherStatus: CurrentWeatherStatus {
        if weatherDescription.contains("clear") {
            return.sun
        } else if weatherDescription.contains("cloud") {
            return .clouds
        } else if weatherDescription.contains("rain") {
            return .rain
        } else { return .clouds }
    }
}


struct ForecastWeather: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cod = try container.decode(String.self, forKey: .cod)
        message = try container.decode(Int.self, forKey: .message)
        cnt = try container.decode(Int.self, forKey: .cnt)
        list = try container.decode([List].self, forKey: .list)
        city = try container.decode(City.self, forKey: .city)
    }
    
    
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}


// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: ForeSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct ForeSys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}




// MARK: - Weather
enum Icon: String, Codable {
    case the02D = "02d"
    case the03D = "03d"
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
}



enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"

}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}


struct CityWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}
