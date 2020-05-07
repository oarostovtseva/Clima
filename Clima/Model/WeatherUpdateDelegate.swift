//
//  WeatherUpdateDelegate.swift
//  Clima
//
//  Created by Olena Rostovtseva on 05.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherUpdateDelegate {
    func weatherDidUpdate(weather: WeatherModel)
    func didFailWithError(error: Error)
}
