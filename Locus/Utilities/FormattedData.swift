//
//  FormattedData.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation

protocol FormattedData {
    func stringFromTimeInterval(_ interval: Int) -> String
    func secondsToHMS(_ seconds: Int) -> (Int, Int, Int)
    func readableTime(_ seconds: Int) -> String
    func convertTemp(kelvin temp: Double) -> String
    func convertTemp(celsius temp: Double) -> String
}

extension FormattedData {
    func secondsToHMS(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func stringFromTimeInterval(_ interval: Int) -> String {
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func readableTime(_ seconds: Int) -> String {
        let (h, m, s) = secondsToHMS(seconds)
        print("\(h) Hours, \(m) Minutes, \(s) Seconds")
        return "\(h):\(m)"
    }
    
    func convertTemp(kelvin temp: Double) -> String {
        let celsiusTemp = temp - 273.15
        return String(format: "%.0f", celsiusTemp)
    }
    
    func convertTemp(celsius temp: Double) -> String {
        let kelvinTemp = temp * 9 / 5 + 32
        return String(format: "%.0f", kelvinTemp)
    }
}
