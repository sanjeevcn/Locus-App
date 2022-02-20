//
//  ContentView.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

struct CityWeatherView: View {
    @EnvironmentObject var model: WeatherViewModel
    
    var body: some View {
        if let weatherData = model.weatherModel {
            VStack {
                List(weatherData.weather, id: \.id) { item in
                    NavigationLink(destination: DetailWeatherView().environmentObject(model)) {
                        cardDesign(item)
                            .listRowSeparator(.hidden)
                    }
                }.listStyle(.plain)
                    .navigationBarTitle("Weather Details")
                
                Spacer()
            }
        } else {
            Text("Please go back and enter valid city name.")
                .padding()
        }
    }
    
    func cardDesign(_ weather: Weather) -> some View {
        VStack(alignment:.leading) {
            HStack(alignment: .top) {
                VStack {
                    Text(weather.main)
                        .font(.system(.title3))
                        .padding(.vertical)
                    Text(weather.weatherDescription)
                        .font(.footnote)
                }
                
                Spacer()
                
                Text("Temp: \(weather.main)")
                    .font(.system(.title2))
                    .bold()
                    .padding(.vertical)
            }
        }.padding().frame(height: 100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherView()
    }
}
