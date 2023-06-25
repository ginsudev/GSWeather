//
//  WeatherDisplayable.swift
//  GSWeather
//
//  Created by Noah Little on 24/6/2023.
//

import Foundation

protocol WeatherDisplayable {
    var temperature: Double { get }
    var high: Double { get }
    var low: Double { get }
    var sunrise: Date { get }
    var sunset: Date { get }
}

extension API.MeteoWeather: WeatherDisplayable {
    var high: Double {
        self.dailyWeather?.high ?? .zero
    }
    
    var low: Double {
        self.dailyWeather?.low ?? .zero
    }
    
    var sunrise: Date {
        self.dailyWeather?.sunrise ?? Date()
    }
    
    var sunset: Date {
        self.dailyWeather?.sunset ?? Date()
    }
    
    var temperature: Double {
        self.currentWeather?.temperature ?? .zero
    }
}
