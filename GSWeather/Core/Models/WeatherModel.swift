//
//  WeatherModel.swift
//  GSWeather
//
//  Created by Noah Little on 20/6/2023.
//

import Foundation

public struct WeatherModel: Codable {
    /// Current temperature
    public let temperature: Temperature
    
    /// Highest temperature of the day
    public let high: Temperature
    
    /// Lowest temperature of the day
    public let low: Temperature
    
    /// Name of the place this weather data is related to
    public let locationName: String?
    
    /// Date representing when sunrise will occur
    public let sunrise: Date
    
    /// Date representing when sunset will occur
    public let sunset: Date
    
    /// The date this weather model was created.
    public let date: Date
    
    public init(
        temperature: Temperature,
        high: Temperature,
        low: Temperature,
        locationName: String?,
        sunrise: Date,
        sunset: Date
    ) {
        self.temperature = temperature
        self.high = high
        self.low = low
        self.locationName = locationName
        self.sunrise = sunrise
        self.sunset = sunset
        self.date = Date()
    }
}

internal extension WeatherModel {
    init(
        displayable: WeatherDisplayable,
        locationName: String?
    ) {
        self.init(
            temperature: .init(celsius: Int(displayable.temperature)),
            high: .init(celsius: Int(displayable.high)),
            low: .init(celsius: Int(displayable.low)),
            locationName: locationName,
            sunrise: displayable.sunrise,
            sunset: displayable.sunset
        )
    }
}
