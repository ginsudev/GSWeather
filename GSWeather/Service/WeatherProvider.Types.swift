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
        
        public static var current: Self {
            switch UnitTemperature.current {
            case .celsius: return .celsius
            case .fahrenheit: return .fahrenheit
            default: return .celsius
            }
        }
    }
    
    enum Provider: URLBuildable {
        // https://api.open-meteo.com/v1/forecast?latitude=-33.87&longitude=151.21&current_weather=true
        case meteo(location: CLLocation, unit: TemperatureUnit = .current)
        
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
            case let .meteo(location, unit):
                return [
                    .init(name: "latitude", value: "\(location.coordinate.latitude)"),
                    .init(name: "longitude", value: "\(location.coordinate.longitude)"),
                    .init(name: "current_weather", value: "true"),
                    .init(name: "temperature_unit", value: unit.rawValue)
                ]
            }
        }
        
        var unit: TemperatureUnit {
            switch self {
            case let .meteo(_, unit): return unit
            }
        }
        
        var location: CLLocation {
            switch self {
            case let .meteo(location, _): return location
            }
        }
    }
}
