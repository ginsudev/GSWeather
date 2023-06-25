//
//  API.MeteoWeather.swift
//  GSWeather
//
//  Created by Noah Little on 18/6/2023.
//

import Foundation

extension API {
    public struct MeteoWeather: Codable {
        public let currentWeather: CurrentWeather?
        public let dailyWeather: DailyWeather?
        
        enum CodingKeys: String, CodingKey {
            case currentWeather = "current_weather"
            case dailyWeather = "daily"
        }
        
        public init(currentWeather: CurrentWeather, dailyWeather: DailyWeather) {
            self.currentWeather = currentWeather
            self.dailyWeather = dailyWeather
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<API.MeteoWeather.CodingKeys> = try decoder.container(keyedBy: API.MeteoWeather.CodingKeys.self)
            self.currentWeather = try container.decodeIfPresent(CurrentWeather.self, forKey: API.MeteoWeather.CodingKeys.currentWeather)
            self.dailyWeather = try container.decodeIfPresent(DailyWeather.self, forKey: API.MeteoWeather.CodingKeys.dailyWeather)
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
    
    struct DailyWeather: Codable {
        public let low: Double
        public let high: Double
        public let sunrise: Date
        public let sunset: Date
        
        enum CodingKeys: String, CodingKey {
            case low = "temperature_2m_min"
            case high = "temperature_2m_max"
            case sunrise
            case sunset
        }
        
        public init(
            low: Double,
            high: Double,
            sunrise: Date,
            sunset: Date
        ) {
            self.low = low
            self.high = high
            self.sunrise = sunrise
            self.sunset = sunset
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<API.MeteoWeather.DailyWeather.CodingKeys> = try decoder.container(keyedBy: API.MeteoWeather.DailyWeather.CodingKeys.self)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            
            guard let low = try container.decode([Double].self, forKey: API.MeteoWeather.DailyWeather.CodingKeys.low).first,
                  let high = try container.decode([Double].self, forKey: API.MeteoWeather.DailyWeather.CodingKeys.high).first,
                  let sunrise = try container.decode([String].self, forKey: API.MeteoWeather.DailyWeather.CodingKeys.sunrise).first,
                  let sunset = try container.decode([String].self, forKey: API.MeteoWeather.DailyWeather.CodingKeys.sunset).first,
                  let sunriseDate = formatter.date(from: sunrise),
                  let sunsetDate = formatter.date(from: sunset)
            else { throw URLError(.cannotDecodeRawData) }

            self.low = low
            self.high = high
            self.sunrise = sunriseDate
            self.sunset = sunsetDate
        }
    }
}

internal extension API.MeteoWeather {
    static var defaultValue: Self {
        .init(
            currentWeather: .init(temperature: .zero),
            dailyWeather: .init(low: .zero, high: .zero, sunrise: Date(), sunset: Date())
        )
    }
}
