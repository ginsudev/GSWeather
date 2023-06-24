//
//  WeatherDisplayable.swift
//  GSWeather
//
//  Created by Noah Little on 24/6/2023.
//

import Foundation

protocol WeatherDisplayable {
    var temperature: Double { get }
}

extension API.MeteoWeather: WeatherDisplayable {
    var temperature: Double {
        self.currentWeather.temperature
    }
}
