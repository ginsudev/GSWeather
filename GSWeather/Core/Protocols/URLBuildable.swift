//
//  URLBuildable.swift
//  GSWeather
//
//  Created by Noah Little on 18/6/2023.
//

import Foundation

protocol URLBuildable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension URLBuildable {
    var scheme: String { "https" }
    
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
