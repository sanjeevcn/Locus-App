//
//  LocationView.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

struct DetailWeatherView: View, FormattedData {
    @EnvironmentObject var model: WeatherViewModel
    
    var body: some View {
        if let detail = model.weatherModel {
            ZStack {
                Color.accentColor.opacity(0.1)
                VStack {
                    VStack {
                        Text("\(detail.name), \(detail.sys.country)")
                            .font(.system(size: 40))
                            .padding()
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(convertTemp(kelvin: detail.main.temp))")
                                    .font(.system(size: 70))
                                    .padding()
                                
                                HStack {
                                    Text("Feels Like:").font(.headline)
                                    Text("\(convertTemp(kelvin: detail.main.feelsLike))").font(.subheadline)
                                }
                            }
                        
                        //TODO: pass systemImage depending on the condition,
                        //MARK: model.getSymbol(for: detail.weather.first?.main)
                        
                            Image(systemName: "cloud.sun.rain.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.yellow)
                        }
                        
                        
                        
                        if let conditions = detail.weather.first {
                            Text("\(conditions.main), \(conditions.weatherDescription)")
                                .font(.title).foregroundColor(.gray)
                                .padding()
                        }
                    }
                    
                    HStack {
                        Text("Latitude: \n\(Double(detail.coord.lat))")
                        Spacer()
                        Text("Longitude: \n\(Double(detail.coord.lon))")
                    }.padding().font(.subheadline)
                    
                    
                    
                    //TODO: fix issue extracting time from timeInterval
                    CustomImageLabel(systemImage: "sunrise.fill", text: "Sunrise at: \(stringFromTimeInterval(detail.sys.sunrise))")
                    
                    CustomImageLabel(systemImage: "sunset.fill", text: "Sunset at: \(stringFromTimeInterval(detail.sys.sunset))")
                    
                    Spacer()
                }.font(.title3)
                    .padding()
            }
        } else {
            Text("Please go back and select a valid city")
        }
    }
}

struct CustomImageLabel: View {
    let systemImage: String
    let text: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.yellow)
            
            Text(text)
        }
    }
}
