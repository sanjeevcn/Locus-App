//
//  ContentView.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

struct CityWeatherView: View, FormattedData {
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
                    .navigationBarTitle(weatherData.name)
                
                Spacer()
            }
        } else {
            Text("Please enter valid city name.")
                .padding()
        }
    }
    
    @ViewBuilder
    func cardDesign(_ item: Weather) -> some View {
        
            VStack(alignment:.leading) {
                HStack(alignment: .top) {
                    VStack {
                        Text(item.main)
                            .font(.system(.title3))
                            .padding(.vertical)
                        Text(item.weatherDescription)
                            .font(.footnote)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    if let weather = model.weatherModel {
                        VStack {
                            Text("\(convertTemp(kelvin: weather.main.temp))")
                                .font(.system(.largeTitle))
                                .bold()
                                .padding(.vertical)
                            
                            Text("Temperature")
                                .font(.footnote)
                            Spacer()
                        }
                    }
                }
            }.padding().frame(idealHeight: 100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherView()
    }
}
