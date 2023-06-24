//
//  UnitTemperature+Extensions.swift
//  GSWeather
//
//  Created by Noah Little on 20/6/2023.
//

import Foundation

extension UnitTemperature {
    static var current: UnitTemperature {
        let measureFormatter = MeasurementFormatter()
        let measurement = Measurement(value: 0, unit: UnitTemperature.celsius)
        let output = measureFormatter.string(from: measurement)
        return output == "0°C" ? .celsius : .fahrenheit
    }
}
