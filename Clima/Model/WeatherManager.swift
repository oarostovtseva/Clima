//
//  WeatherManager.swift
//  Clima
//
//  Created by Olena Rostovtseva on 04.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherManager {
    var weatherUpdateDelegate: WeatherUpdateDelegate?

    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=943d9bc976b310d598653e5cb7fd5d47"

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: url) { data, _, error in
                if let safeError = error {
                    print(error.debugDescription)
                    self.weatherUpdateDelegate?.didFailWithError(error: safeError)
                    return
                }
                if let safeData = data {
                    if let weatherModel = self.parseJson(safeData) {
                        self.weatherUpdateDelegate?.weatherDidUpdate(weather: weatherModel)
                    }
                }
            }

            dataTask.resume()
        }
    }

    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp

            let weatherModel = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weatherModel
        } catch {
            print(error)
            weatherUpdateDelegate?.didFailWithError(error: error)
            return nil
        }
    }
}
