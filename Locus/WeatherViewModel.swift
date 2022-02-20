//
//  LocationViewModel.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject, FormattedData {
    
    static let shared = WeatherViewModel()
    
    enum ActiveAlert { case custom(_ message: String) }
    
    @Published var activeAlert: ActiveAlert?
    @Published var isLoading: Bool
    @Published var errorMessage: Error?
    @Published var weatherModel: WeatherModel?
    @Published var detailWeatherData: WeatherModel?
    
    @Published var isValidCityData: Bool
    @Published var detailData: Bool
    @Published var city: String = "Panaji, Goa"//test
    
    @ObservedObject var locationManager = LocationManager()
    
    @AppStorage("listOfSearches", store: .standard) var listOfSearches: String = ""
    
    init() {
        self.isLoading = false
        self.errorMessage = nil
        self.weatherModel = nil
        self.isValidCityData = false
        self.detailData = false
        self.detailWeatherData = nil
    }
}

extension WeatherViewModel: ServiceHandler {
    
    func fetchWeather(for city: String) async {
        
        Task { self.isLoading = true }
        defer { Task { self.isLoading = false } }
        
        do {
            let weatherModel: WeatherModel = try await serve(endpoint: .fetchWeather(city: city))
            DispatchQueue.main.async {
                self.weatherModel = weatherModel
                self.isValidCityData = true
            }
            
        } catch (let err as CustomError) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        } catch (let err) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        }
    }
}

extension WeatherViewModel {
    
    func getSymbol(for condition: String) -> String {
        
        //MARK: NEED to send the assignment, no time to add these symbols
        let _ = [
            "sun.min.fill",
            "sun.max.fill",
            "sunrise.fill",
            "sunset.fill",
            "sun.dust.fill",
            "sun.haze.fill",
            "moon.fill",
            "moon.circle.fill",
            "moon.stars.fill",
            "cloud.fill",
            "cloud.drizzle.fill",
            "cloud.rain.fill",
            "cloud.heavyrain.fill",
            "cloud.fog.fill",
            "cloud.hail.fill",
            "cloud.snow.fill",
            "cloud.sleet.fill",
            "cloud.bolt.fill",
            "cloud.bolt.rain.fill",
            "cloud.sun.fill",
            "cloud.sun.rain.fill",
            "cloud.sun.bolt.fill",
            "cloud.moon.fill",
            "cloud.moon.rain.fill",
            "cloud.moon.bolt.fill",
            "smoke.fill",
            "wind.snow",
            "tornado",
            "tropicalstorm",
            "hurricane"
        ]
        
        switch condition {
        case "Smoke":
            return "sunrise.fill"
        default: return "cloud.sun.rain.fill"
        }
    }
}
