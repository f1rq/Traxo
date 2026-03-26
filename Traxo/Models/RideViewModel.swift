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
    
    func start() {
        guard state != .running else { return }
        
        state = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    func pause() {
        state = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func stop() -> Ride? {
        timer?.invalidate()
        timer = nil
        
        var savedRide: Ride? = nil
        if elapsedSeconds > 0 {
            savedRide = Ride(
                distance: Double.random(in: 1...20),
                duration: elapsedSeconds,
                date: Date()
            )
        }
        
        elapsedSeconds = 0
        state = .idle
        return savedRide
    }
    
    var formattedTime: String {
        let h = elapsedSeconds / 3600
        let m = (elapsedSeconds % 3600) / 60
        let s = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
