import ActivityKit
import Foundation

struct TraxoActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var distanceKm: Double
        var currentSpeedKmh: Double
        var elapsedSeconds: Int
        var isPaused: Bool
        var isAutoPaused: Bool
    }
    
    var startDate: Date
}
