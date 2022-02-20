//
//  ApiEndpoint.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation

enum ApiEndpoint {
//    case fetchWeather(lat: Double, long: Double)
    case geoCoding(city: String)
    case fetchWeather(city: String)
    case fetchWeatherHourly(city: String, stateCode: String?)
    
    var description: String {
        return baseUrl + path
    }
    
    var authToken: String {
        return "65d00499677e59496ca2f318eb68c049"
    }
    
    var baseUrl: String {
        return "http://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .fetchWeather:
            return "/data/2.5/weather"
        case .fetchWeatherHourly:
            return "/data/2.5/forecast/hourly"
        case .geoCoding:
            return "/geo/1.0/direct?q=London&limit=5&appid={API key}"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchWeather(let city):
            return [.init(name: "q", value: city),
                    .init(name: "appid", value: authToken)]
            
        case .fetchWeatherHourly(let city, let stateCode):
            let qValue: String = ((stateCode != nil) ? city + ", " + (stateCode ?? "") : city)
            return [.init(name: "q", value: qValue),
                    .init(name: "appid", value: authToken)]
            
        case .geoCoding(let city):
            return [.init(name: "q", value: city),
                    .init(name: "limit", value: "5"),
                    .init(name: "appid", value: authToken)]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .fetchWeather, .fetchWeatherHourly, .geoCoding:
            return "GET"
        }
    }
    
    var request: URLRequest {
        var urlComponents: URLComponents = URLComponents(string: baseUrl)!
        urlComponents.path = path
        
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod
        
        if httpMethod == "POST" {}//Body for POST Request
        debugPrint(request)
        return request
    }
}

extension ApiEndpoint: Equatable {
    static func == (lhs: ApiEndpoint, rhs: ApiEndpoint) -> Bool {
        return lhs.path == rhs.path
    }
}
