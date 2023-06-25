//
//  WeatherProvider.Types.swift
//  GSWeather
//
//  Created by Noah Little on 18/6/2023.
//

import Foundation
import CoreLocation

public extension WeatherProvider {
    enum WeatherError: Error {
        case badResponse
        case badData
    }
    
    enum TemperatureUnit: String {
        case fahrenheit
        case celsius
        
        public var symbol: String {
            switch self {
            case .celsius: return "°C"
            case .fahrenheit: return "°F"
            }
        }
    }
    
    enum Provider: URLBuildable {
        // https://api.open-meteo.com/v1/forecast?latitude=-33.87&longitude=151.21&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&temperature_unit=celsius&forecast_days=1&timezone=auto
        case meteo(location: CLLocation, timezone: TimeZone)
        
        var host: String {
            switch self {
            case .meteo: return "api.open-meteo.com"
            }
        }
        
        var path: String {
            switch self {
            case .meteo: return "/v1/forecast"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case let .meteo(location, timezone):
                return [
                    .init(name: "latitude", value: "\(location.coordinate.latitude)"),
                    .init(name: "longitude", value: "\(location.coordinate.longitude)"),
                    .init(name: "daily", value: "temperature_2m_max,temperature_2m_min,sunrise,sunset"),
                    .init(name: "current_weather", value: "true"),
                    .init(name: "temperature_unit", value: "celsius"),
                    .init(name: "forecast_days", value: "1"),
                    .init(name: "timezone", value: timezone.identifier)
                ]
            }
        }
        
        var location: CLLocation {
            switch self {
            case let .meteo(location, _): return location
            }
        }
    }
}
