import ActivityKit
import Foundation

nonisolated struct TraxoActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        var distanceKm: Double
        var currentSpeedKmh: Double
        var elapsedSeconds: Int
        var isPaused: Bool
    }
    
    var startDate: Date
}
