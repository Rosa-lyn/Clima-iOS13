//
//  WeatherManager.swift
//  Clima
//
//  Created by Rosalyn Land on 16/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid={apiKey}"

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
    }

    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print(error)
            return
        }

        if let data = data {
            let dataString = String(data: data, encoding: .utf8)
            print(dataString)
        }
    }
}
