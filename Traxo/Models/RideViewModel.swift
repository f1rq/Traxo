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

enum RideState: String, Codable {
    case idle
    case running
    case paused
}

@MainActor
@Observable
class RideViewModel {
    var elapsedSeconds: Int = 0
    var state: RideState = .idle
    
    private var currentActivity: Activity<TraxoActivityAttributes>? = nil
    private var timer: Timer?
    private(set) var locationManager = LocationManager()
    
    private var accumulatedTime: TimeInterval {
        get { UserDefaults.standard.double(forKey: "traxo_accumulatedTime") }
        set { UserDefaults.standard.set(newValue, forKey: "traxo_accumulatedTime") }
    }
    
    private var currentSegmentStartDate: Date? {
        get { UserDefaults.standard.object(forKey: "traxo_segmentStart") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "traxo_segmentStart") }
    }
    
    init() {
        restoreActiveSession()
    }
    
    private func restoreActiveSession() {
        if let existingActivity = Activity<TraxoActivityAttributes>.activities.first {
            self.currentActivity = existingActivity
            let savedStateRaw = UserDefaults.standard.string(forKey: "traxo_rideState") ?? "running"
            self.state = RideState(rawValue: savedStateRaw) ?? .running
            
            recalculateElapsedSeconds()
            
            if self.state == .running {
                startTimer()
            }
        } else {
            clearPersistedState()
        }
    }

    func start() {
        guard state != .running else { return }
        
        if state == .idle {
            clearPersistedState()
            accumulatedTime = 0
            elapsedSeconds = 0
            currentSegmentStartDate = Date()
            locationManager.startNewRide()
            startLiveActivity()
        } else {
            currentSegmentStartDate = Date()
            locationManager.resumeTracking()
        }
        
        state = .running
        saveState()
        startTimer()
        updateLiveActivity()
    }
    
    func pause() {
        guard state == .running else { return }
        
        if let segmentStart = currentSegmentStartDate {
            accumulatedTime += Date().timeIntervalSince(segmentStart)
            currentSegmentStartDate = nil
        }
        
        state = .paused
        saveState()
        stopTimer()
        recalculateElapsedSeconds()
        locationManager.pauseTracking()
        updateLiveActivity()
    }
    
    func stop() -> Ride? {
        stopTimer()
        
        if let segmentStart = currentSegmentStartDate {
            accumulatedTime += Date().timeIntervalSince(segmentStart)
            currentSegmentStartDate = nil
        }
        recalculateElapsedSeconds()
        
        endLiveActivity()
        
        var savedRide: Ride? = nil
        if elapsedSeconds > 0 {
            let coords = locationManager.stopTracking()
            savedRide = Ride(
                distance: locationManager.totalDistance / 1000,
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
        clearPersistedState()
        elapsedSeconds = 0
        return savedRide
    }
    
    private func recalculateElapsedSeconds() {
        var total = accumulatedTime
        if state == .running, let segmentStart = currentSegmentStartDate {
            total += Date().timeIntervalSince(segmentStart)
        }
        elapsedSeconds = Int(total)
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if self.state == .running {
                    self.recalculateElapsedSeconds()
                    
                    if self.locationManager.currentSpeed > 0.6 {
                        self.locationManager.movingSeconds += 1
                    }
                }
                
                if self.elapsedSeconds % 2 == 0 {
                    self.updateLiveActivity()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func saveState() {
        UserDefaults.standard.set(state.rawValue, forKey: "traxo_rideState")
    }
    
    private func clearPersistedState() {
        UserDefaults.standard.removeObject(forKey: "traxo_accumulatedTime")
        UserDefaults.standard.removeObject(forKey: "traxo_segmentStart")
        UserDefaults.standard.removeObject(forKey: "traxo_rideState")
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
        let movingSecs = locationManager.movingSeconds
        guard movingSecs > 0 else { return 0 }
        let distance = locationManager.totalDistance / 1000
        let durationHours = Double(movingSecs) / 3600
        return distance / durationHours
    }
    
    private func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
                
        let attributes = TraxoActivityAttributes(startDate: Date())
        let initialState = TraxoActivityAttributes.ContentState(
            distanceKm: locationManager.totalDistance / 1000,
            currentSpeedKmh: locationManager.currentSpeed * 3.6,
            elapsedSeconds: elapsedSeconds,
            isPaused: false
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
            isPaused: state == .paused
        )
        
        let content = ActivityContent(state: updatedState, staleDate: nil)
        
        Task {
            await activity.update(content)
        }
    }
        
    private func endLiveActivity() {
        guard let activity = currentActivity else { return }
        
        let finalState = TraxoActivityAttributes.ContentState(
            distanceKm: locationManager.totalDistance / 1000,
            currentSpeedKmh: 0,
            elapsedSeconds: elapsedSeconds,
            isPaused: false
        )
        let finalContent = ActivityContent(state: finalState, staleDate: nil)
        self.currentActivity = nil
        
        Task {
            await activity.end(finalContent, dismissalPolicy: .immediate)
        }
    }
}
