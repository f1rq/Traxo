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

struct Ride: Identifiable, Codable {
    var id = UUID()
    let distance: Double
    let duration: Int
    let date: Date
}

@Observable
class RideViewModel {
    var elapsedSeconds: Int = 0
    var state: RideState = .idle
    
    var rides: [Ride] = []
    
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
    
    func stop() {
        timer?.invalidate()
        timer = nil
        
        if elapsedSeconds > 0 {
            let newRide = Ride(
                distance: Double.random(in: 1...20),
                duration: elapsedSeconds,
                date: Date()
            )
            
            rides.insert(newRide, at: 0)
        }
        
        elapsedSeconds = 0
        state = .idle
    }
    
    var formattedTime: String {
        let h = elapsedSeconds / 3600
        let m = (elapsedSeconds % 3600) / 60
        let s = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
