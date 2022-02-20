//
//  LandingView.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var model: WeatherViewModel
    
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
            
            if model.weatherModel != nil {
                VStack {
                    NavigationLink(destination:
                                    CityWeatherView()
                                    .environmentObject(model),
                                   isActive: $model.isValidCityData){ EmptyView()
                    }
                }.hidden()
            }
            
            CustomTextField(data: $model.city)
                .frame(width: 200, height: 50, alignment: .center)
            
            Button("Lookup") {
                Task {
                    guard model.city.count > 3 else {
                        model.activeAlert = .custom("Please enter city name!")
                        return
                    }
                    await model.fetchWeather(for: model.city)
                }
            }.buttonStyle(RoundedButtonStyle())
            
            Spacer()
        }.edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            model.city = ""
            model.locationManager.checkPermissions()
        })
    }
}



struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.black)
            Spacer()
        }.padding()
        .frame(width: 200, height: 50, alignment: .center)
        .background(Color.yellow.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}
