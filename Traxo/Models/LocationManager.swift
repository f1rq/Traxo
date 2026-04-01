//
//  LocationManager.swift
//  Traxo
//
//  Created by Fabio Czudaj on 01/04/2026.
//

import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var totalDistance: Double = 0
    var currentSpeed: Double = 0
    var maxSpeed: Double = 0
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
    }
    
    func startTracking() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        routeCoordinates = []
        totalDistance = 0
        currentSpeed = 0
        maxSpeed = 0
    }
    
    func stopTracking() -> [CLLocationCoordinate2D] {
        manager.stopUpdatingLocation()
        let route = routeCoordinates
        routeCoordinates = []
        totalDistance = 0
        currentSpeed = 0
        return route
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        if newLocation.speed >= 0 {
            currentSpeed = newLocation.speed
            if currentSpeed > maxSpeed {
                maxSpeed = currentSpeed
            }
        }
        
        if let lastLocation = currentLocation {
            let distance = newLocation.distance(from: lastLocation)
            totalDistance += distance
        }
        
        currentLocation = newLocation
        routeCoordinates.append(newLocation.coordinate)
    }
        
}
