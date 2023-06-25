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
    
    private var location = PassthroughSubject<CLLocation, Never>()
    private var locationName = PassthroughSubject<String?, Never>()
    private var fetchedWeather = PassthroughSubject<WeatherDisplayable, Never>()
    
    public var currentWeather = CurrentValueSubject<WeatherModel?, Never>(nil)
    
    public init() {
        self.service = .init()
        self.locationProvider = .init()
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
        location
            .flatMap(locationProvider.getLocationName)
            .sink { [weak self] in self?.locationName.send($0) }
            .store(in: &bag)
        
        // Store weather after successful fetch
        service.fetchedWeather
            .sink { [weak self] in self?.fetchedWeather.send($0) }
            .store(in: &bag)
        
        // Wait until location name and weather have been stored, then merge and send.
        Publishers.Zip(fetchedWeather, locationName)
            .map { WeatherModel(displayable: $0, locationName: $1) }
            .sink { [weak self] in self?.currentWeather.send($0) }
            .store(in: &bag)
    }
}
