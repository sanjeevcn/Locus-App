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
            Spacer(minLength: 50)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Locus ")
                    Image(systemName: "cloud.sun.rain.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }.foregroundColor(.yellow).font(.system(.largeTitle))
                Text("Weather Forecasts").foregroundColor(.gray).font(.system(.title3))
            }.padding()
            
            Spacer(minLength: 20)
            
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
                .frame(width: 300, height: 50, alignment: .center)
            
            Button("Lookup") {
                Task {
                    guard model.city.count > 3 else {
                        model.activeAlert = .custom("Please enter city name!")
                        return
                    }
                    
                    if !model.listOfSearches.contains(model.city.removingSpaces) {
                        model.listOfSearches.append("\(model.city),")
                    }
                    await model.fetchWeather(for: model.city)
                }
            }.buttonStyle(RoundedButtonStyle())
            
            recentSearches()
            
            Spacer()
        }.edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            model.city = ""
            model.locationManager.checkPermissions()
        })
    }
    
    @ViewBuilder
    func recentSearches() -> some View {
        let searches = model.listOfSearches.components(separatedBy: ",")
        
        if searches.count > 2 {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Searches:").font(.headline)
                    ForEach(searches.indices) { idx in
                        Text(searches[idx].removingSpaces)
                            .font(.subheadline)
                            .onTapGesture {
                                Task {
                                    await model.fetchWeather(for: searches[idx].removingSpaces)
                                }
                            }
                    }
                }
            }.frame(height: 150).padding()
        } else {
            EmptyView()
        }
    }
}

extension String {
    var removingSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
}


struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.black)
            Spacer()
        }.padding()
        .frame(width: 300, height: 50, alignment: .center)
        .background(Color.yellow.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}
