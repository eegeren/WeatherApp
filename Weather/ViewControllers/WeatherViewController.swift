//
//  ViewController.swift
//  Weather
//
//  Created by Ege on 18.05.2023.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    var networkManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    //MARK: - UI
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        return stackView
    }()
    
    private let weatherImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let minimumTemperatureLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private let maximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let searchButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.title = "Merhaba"
        config.subtitle = "Şehir seçiniz"
        config.image = UIImage(systemName: "magnifyingglass.circle.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        let button = UIButton(configuration: config, primaryAction: nil)
        button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    private let backgroundImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage (named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
    }()
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(with: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        layout()
    }
    
    //MARK: - Methods
    @objc private func searchPressed() {
        presentSearchAlertController(title: "Şehir Adı Giriniz", message: nil, style: .alert) { [unowned self] city in
            networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    func updateInterface(with weather: CurrentWeather) {
        DispatchQueue.main.async { [self] in
            minimumTemperatureLabel.text = """
MIN
\(weather.minimumTemperatureString)°C
"""
            maximumTemperatureLabel.text = """
MAKS
\(weather.maximumTemperatureString)°C
"""
            temperatureLabel.text = "\(weather.temperatureString)°C"
            feelsLikeLabel.text = "Hissedilen \(weather.feelsLikeTemperatureString) °C"
            searchButton.configuration?.title = weather.cityName
            searchButton.configuration?.subtitle = weather.country
            weatherImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
    //MARK: - Layout
    private func layout() {
        view.addSubview(backgroundImage)
        view.addSubview(mainStackView)
        view.addSubview(searchButton)
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(feelsLikeLabel)
        topStackView.addArrangedSubview(minimumTemperatureLabel)
        topStackView.addArrangedSubview(weatherImageView)
        topStackView.addArrangedSubview(maximumTemperatureLabel)
        
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 250),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            weatherImageView.widthAnchor.constraint(equalToConstant: 150),
            weatherImageView.heightAnchor.constraint(equalToConstant: 150),
            
            feelsLikeLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -50),
            
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

 
