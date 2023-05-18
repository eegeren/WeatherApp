//
//  CurrentWeather.swift
//  Weather
//
//  Created by Ege on 18.05.2023.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    let country: String
    let temperature, feelsLikeTemperature, minimumTemperature, maximumTemperature: Double
    let condicitionCode: Int
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    var minimumTemperatureString: String {
        return String(format: "%.0f", minimumTemperature)
    }
    
    var maximumTemperatureString: String {
        return String(format: "%0.f", maximumTemperature)
    }
    
    var systemIconNameString: String {
        switch condicitionCode {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.min"
        case 801...804: return "cloud"
        default: return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        country = currentWeatherData.sys.country
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        minimumTemperature = currentWeatherData.main.tempMin
        maximumTemperature = currentWeatherData.main.tempMax
        condicitionCode = currentWeatherData.weather.first!.id
    }
    
}
