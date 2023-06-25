//
//  Temperature.swift
//  GSWeather
//
//  Created by Noah Little on 25/6/2023.
//

import Foundation

public struct Temperature: Codable {
    /// Celsius representation of the current temperature, including ºC symbol.
    public let celsius: String
    
    /// Fahrenheit representation of the current temperature, including ºF symbol.
    public let fahrenheit: String
    
    public init(celsius: Int) {
        let fahrenheit = (celsius * 9/5) + 32
        self.celsius = "\(celsius)\(WeatherProvider.TemperatureUnit.celsius.symbol)"
        self.fahrenheit = "\(fahrenheit)\(WeatherProvider.TemperatureUnit.fahrenheit.symbol)"
    }
}
