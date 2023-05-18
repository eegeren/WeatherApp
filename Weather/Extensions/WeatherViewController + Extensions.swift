//
//  WeatherViewController + Extension.swift
//  Weather
//
//  Created by Ege on 18.05.2023.
//

import UIKit
import CoreLocation

extension WeatherViewController {
    func presentSearchAlertController(title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { tf in
            let cities = ["San Francisco", "Oslo", "New York", "Istanbul", "Berlin"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Ara", style: .default) { _ in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
        }
    }
        let cancel = UIAlertAction(title: "İptal", style: .cancel)
        alertController.addAction(search)
        alertController.addAction(cancel)
        present(alertController, animated: true)
}
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
