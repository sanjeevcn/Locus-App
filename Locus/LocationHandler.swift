//
//  LocationHandler.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {

    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus?
    @Published var latestLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func requestAuthorisation() {
//        locationManager.requestAlwaysAuthorization() //This will drain the battery
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager {

    func locationCoordinates() {
        var userLatitude: String {
            return "\(latestLocation?.coordinate.latitude ?? 0)"
        }
        
        var userLongitude: String {
            return "\(latestLocation?.coordinate.longitude ?? 0)"
        }
    }
    
    func checkPermissions() {
        if authorisationStatus == .notDetermined {
            requestAuthorisation()
        }
    }
    
    var status: String {
        guard let status = authorisationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latestLocation = location
        print(location)
    }
}
