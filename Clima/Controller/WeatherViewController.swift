//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // executes when return is pressed
        searchTextField.endEditing(true)
        return true
    }

    // any textfield methods with should in the name asks for permission, hence why they return a Bool
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // this method is good for validating user input
        // it prevents the user from ending editing, dismissing keyboard etc if their input is not valid
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }

    // by inheriting from UITextFieldDelegate, the view controller is notified when text field ends editing etc
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this method executes when user stops editing text field
        // use searchTextField.text to get the weather for that city
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }

        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .authorized:
            locationManager.requestLocation()
        default:
            return
        }
    }
}
