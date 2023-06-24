//
//  WeatherModel.swift
//  GSWeather
//
//  Created by Noah Little on 20/6/2023.
//

import Foundation

public struct WeatherModel: Codable {
    public let temperature: Double
    public let placeName: String?
    public let date: Date
    
    public init(temperature: Double, placeName: String?) {
        self.temperature = temperature
        self.placeName = placeName
        self.date = Date()
    }
}
