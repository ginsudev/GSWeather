//
//  Weather.swift
//  GSWeather
//
//  Created by Noah Little on 25/4/2023.
//

import Foundation
import CoreLocation
import Combine

public final class WeatherProvider {    
    private var bag: Set<AnyCancellable> = []
    private let service: WeatherService
    private let locationProvider: LocationProvider
    
    private let location = PassthroughSubject<CLLocation, Never>()
    private let fetchedWeather = PassthroughSubject<WeatherDisplayable, Never>()
    private let currentWeatherSubject = CurrentValueSubject<WeatherModel?, Never>(nil)
    
    public var currentWeatherPublisher: AnyPublisher<WeatherModel?, Never> {
        currentWeatherSubject.eraseToAnyPublisher()
    }
    
    public init() {
        service = .init()
        locationProvider = .init()
        subscribe()
    }
     
    public func fetchWeather(provider: Provider) {
        self.location.send(provider.location)
        
        switch provider {
        case .meteo: service.fetchMeteoWeather(url: provider.url())
        }
    }
}

private extension WeatherProvider {
    func subscribe() {
        // Get location name after location stored
        let locationNamePublisher = location
            .flatMap(locationProvider.getLocationName)
        
        // Store weather after successful fetch
        service.fetchedWeatherPublisher
            .sink { [weak self] in self?.fetchedWeather.send($0) }
            .store(in: &bag)
        
        // Wait until location name and weather have been stored, then merge and send.
        Publishers.Zip(fetchedWeather, locationNamePublisher)
            .map { WeatherModel(displayable: $0, locationName: $1) }
            .sink { [weak self] in self?.currentWeatherSubject.send($0) }
            .store(in: &bag)
    }
}
