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
