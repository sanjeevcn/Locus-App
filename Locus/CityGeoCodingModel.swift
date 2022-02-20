//
//  CityGeoCodingModel.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation

struct CityGeoCodingModelElement: Codable {
    let name: String
    let localNames: LocalNames
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

struct LocalNames: Codable {
    let en: String
}

typealias CityGeoCodingModel = [CityGeoCodingModelElement]
