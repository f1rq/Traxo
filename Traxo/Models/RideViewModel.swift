//
//  RideViewModel.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import Foundation
import Observation

enum RideState {
    case idle
    case running
    case paused
}

@Observable
class RideViewModel {
    var elapsedSeconds: Int = 0
    var state: RideState = .idle
    
    private var timer: Timer?
    private(set) var locationManager = LocationManager()
    
    func start() {
        guard state != .running else { return }
        
        if state == .idle {
            elapsedSeconds = 0
            locationManager.startNewRide()
        } else {
            locationManager.resumeTracking()
        }
        
        state = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }
    
    func pause() {
        guard state == .running else { return }
        state = .paused
        timer?.invalidate()
        timer = nil
        locationManager.pauseTracking()
    }
    
    func stop() -> Ride? {
        timer?.invalidate()
        timer = nil
        
        var savedRide: Ride? = nil
        if elapsedSeconds > 0 {
            savedRide = Ride(
                distance: locationManager.totalDistance / 1000, // meters to km
                duration: elapsedSeconds,
                date: Date(),
                maxSpeed: locationManager.maxSpeed * 3.6,
                avgSpeed: avgSpeed
            )
        }
        
        _ = locationManager.stopTracking()
        state = .idle
        elapsedSeconds = 0
        return savedRide
    }
    
    var formattedTime: String {
        let h = elapsedSeconds / 3600
        let m = (elapsedSeconds % 3600) / 60
        let s = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    var formattedDistance: String {
        String(format: "%.1f", locationManager.totalDistance / 1000)
    }
    
    var formattedSpeed: String {
        String(format: "%.0f", locationManager.currentSpeed * 3.6)
    }
    
    var formattedMaxSpeed: String {
        String(format: "%.0f", locationManager.maxSpeed * 3.6)
    }
    
    var avgSpeed: Double {
        guard elapsedSeconds > 0 else { return 0 }
        let distance = locationManager.totalDistance / 1000
        let duration = Double(elapsedSeconds) / 3600
        return distance / duration
    }
}
