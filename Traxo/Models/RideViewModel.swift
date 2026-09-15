//
//  RideViewModel.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import Foundation
import Observation
import CoreLocation
import ActivityKit

enum RideState {
    case idle
    case running
    case paused
}

@Observable
class RideViewModel {
    var elapsedSeconds: Int = 0
    var state: RideState = .idle
    var isAutoPaused = false
    
    private var currentActivity: Activity<TraxoActivityAttributes>? = nil
    
    private var timer: Timer?
    private(set) var locationManager = LocationManager()
    
    init() {
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        locationManager.onAutoPause = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isAutoPaused = true
                self.timer?.invalidate()
                self.timer = nil
                self.updateLiveActivity()
            }
        }
        
        locationManager.onAutoResume = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isAutoPaused = false
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    self?.elapsedSeconds += 1
                    self?.updateLiveActivity()
                }
            }
        }
    }
    
    func start() {
        guard state != .running else { return }
        
        if state == .idle {
            elapsedSeconds = 0
            locationManager.startNewRide()
            startLiveActivity()
        } else {
            locationManager.resumeTracking()
        }
        
        state = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
            
            if (self?.elapsedSeconds ?? 0) % 2 == 0 {
                self?.updateLiveActivity()
            }
        }
        updateLiveActivity()
    }
    
    func pause() {
        guard state == .running else { return }
        state = .paused
        timer?.invalidate()
        timer = nil
        locationManager.pauseTracking()
        updateLiveActivity()
    }
    
    func stop() -> Ride? {
        timer?.invalidate()
        timer = nil
        endLiveActivity()
        
        var savedRide: Ride? = nil
        if elapsedSeconds > 0 {
            let coords = locationManager.stopTracking()
            savedRide = Ride(
                distance: locationManager.totalDistance / 1000, // meters to km
                duration: elapsedSeconds,
                date: Date(),
                maxSpeed: locationManager.maxSpeed * 3.6,
                avgSpeed: avgSpeed,
                rideLatitudes: coords.map { $0.latitude },
                rideLongitudes: coords.map { $0.longitude }
            )
        } else {
            _ = locationManager.stopTracking()
        }
        
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
    
    private func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities ae disabled in settings")
            return
        }
                
        let attributes = TraxoActivityAttributes(startDate: Date())
        let initialState = TraxoActivityAttributes.ContentState(
            distanceKm: locationManager.totalDistance / 1000,
            currentSpeedKmh: locationManager.currentSpeed * 3.6,
            elapsedSeconds: elapsedSeconds,
            isPaused: false,
            isAutoPaused: false
        )
        
        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil)
            )
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    private func updateLiveActivity() {
        guard let activity = currentActivity else { return }
        
        let updatedState = TraxoActivityAttributes.ContentState(
            distanceKm: locationManager.totalDistance / 1000,
            currentSpeedKmh: locationManager.currentSpeed * 3.6,
            elapsedSeconds: elapsedSeconds,
            isPaused: state == .paused,
            isAutoPaused: isAutoPaused
        )
        
        Task {
            await activity.update(using: updatedState)
        }
    }
        
    private func endLiveActivity() {
        guard let activity = currentActivity else { return }
        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.currentActivity = nil
        }
    }
}
