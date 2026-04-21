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
    private var isRecording = false
    
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
        manager.activityType = .automotiveNavigation
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.requestAlwaysAuthorization()
    }
    
    func startNewRide() {
        routeCoordinates = []
        totalDistance = 0
        currentSpeed = 0
        maxSpeed = 0
        currentLocation = nil
        isRecording = true
        manager.startUpdatingLocation()
    }
    
    func resumeTracking() {
        currentLocation = nil
        currentSpeed = 0
        isRecording = true
        manager.startUpdatingLocation()
    }
    
    func pauseTracking() {
        isRecording = false
        currentSpeed = 0
        manager.stopUpdatingLocation()
    }
    
    func stopTracking() -> [CLLocationCoordinate2D] {
        isRecording = false
        currentSpeed = 0
        manager.stopUpdatingLocation()
        return routeCoordinates
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("📍 lokalizacja: \(locations.last?.coordinate ?? CLLocationCoordinate2D()), isRecording: \(isRecording)")

        guard isRecording, let newLocation = locations.last else { return }
        
        guard newLocation.horizontalAccuracy >= 0,
              newLocation.horizontalAccuracy <= 30 else { return }
        
        guard newLocation.timestamp.timeIntervalSinceNow > -3 else { return }
        
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
