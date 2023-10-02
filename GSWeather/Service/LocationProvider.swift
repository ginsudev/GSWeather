//
//  LocationProvider.swift
//  GSWeather
//
//  Created by Noah Little on 24/6/2023.
//

import Foundation
import CoreLocation
import Combine

internal struct LocationProvider {
    private let geoCoder = CLGeocoder()
    
    func getLocationName(location: CLLocation?) -> AnyPublisher<String?, Never> {
        Deferred {
            Future { promise in
                guard let location else {
                    promise(.success(nil))
                    return
                }
                
                self.geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                    guard error == nil,
                          let placemark = placemarks?.first,
                          let cityName = placemark.locality else {
                        promise(.success(nil))
                        return
                    }
                    
                    promise(.success(cityName))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
