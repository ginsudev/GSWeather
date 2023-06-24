//
//  API.MeteoWeather.swift
//  GSWeather
//
//  Created by Noah Little on 18/6/2023.
//

import Foundation

extension API {
    public struct MeteoWeather: Codable {
        public let currentWeather: CurrentWeather
        
        enum CodingKeys: String, CodingKey {
            case currentWeather = "current_weather"
        }
        
        public init(currentWeather: CurrentWeather) {
            self.currentWeather = currentWeather
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<API.MeteoWeather.CodingKeys> = try decoder.container(keyedBy: API.MeteoWeather.CodingKeys.self)
            self.currentWeather = try container.decode(CurrentWeather.self, forKey: API.MeteoWeather.CodingKeys.currentWeather)
        }
    }
}

public extension API.MeteoWeather {
    struct CurrentWeather: Codable {
        public let temperature: Double
        
        public init(temperature: Double) {
            self.temperature = temperature
        }
    }
}

internal extension API.MeteoWeather {
    static var defaultValue: Self {
        .init(currentWeather: .init(temperature: .zero))
    }
}
