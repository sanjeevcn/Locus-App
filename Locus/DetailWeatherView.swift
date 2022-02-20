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
            VStack {
                HStack {
                    Text("City: \(detail.name)")
                    Text("Country: \(detail.sys.country)")
                }.font(.title2)
                
                HStack {
                    Text("Sunrise: \(readableTime(detail.sys.sunrise))")
                    Text("Sunset: \(readableTime(detail.sys.sunset))")
                }.font(.footnote)
                
                HStack {
                    Text("Latitude: \(detail.coord.lat)")
                    Text("Longitude: \(detail.coord.lon)")
                }.font(.footnote)
            }
        } else {
            Text("Please go back and select a valid city")
        }
    }
}
