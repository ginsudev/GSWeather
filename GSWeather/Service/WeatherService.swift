//
//  WeatherService.swift
//  GSWeather
//
//  Created by Noah Little on 21/6/2023.
//

import Foundation
import Combine

// MARK: - Internal

internal final class WeatherService {
    typealias WeatherError = WeatherProvider.WeatherError
    
    private var bag: Set<AnyCancellable> = []
    private(set) var fetchedWeather = PassthroughSubject<WeatherDisplayable, Never>()
        
    func fetchMeteoWeather(url: URL?) {
        guard let url else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { [weak self] in
                try self?.decodeWeather(data: $0, response: $1, returnType: API.MeteoWeather.self)
            }
            .replaceNil(with: .defaultValue)
            .replaceError(with: .defaultValue)
            .sink { [weak self] value in
                self?.fetchedWeather.send(value)
            }
            .store(in: &bag)
    }
}

// MARK: - Private

private extension WeatherService {
    func isValidResponse(_ response: URLResponse) -> Bool {
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode)
        else { return false }
        
        return true
    }
    
    func decodeWeather<T: Codable&WeatherDisplayable>(
        data: Data,
        response: URLResponse,
        returnType: T.Type
    ) throws -> T {
        guard isValidResponse(response) == true
        else { throw WeatherError.badResponse }
        
        guard let weather = try? JSONDecoder().decode(returnType.self, from: data)
        else { throw WeatherError.badData }
        
        return weather
    }
}
