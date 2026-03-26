//
//  Ride.swift
//  Traxo
//
//  Created by Fabio Czudaj on 26/03/2026.
//

import SwiftData
import Foundation

@Model
class Ride {
    var title: String
    var distance: Double
    var duration: Int
    var date: Date
    
    init(distance: Double, duration: Int, date: Date) {
        self.title = "Untitled ride"
        self.distance = distance
        self.duration = duration
        self.date = date
    }
}

extension Ride {
    var formattedDistance: String {
        distance.formatted(.number.precision(.fractionLength(1))) + " km"
    }
    
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(duration)) ?? ""
    }
    
    var formattedDate: String {
        let calendar = Calendar.current
        let rideYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = (rideYear == currentYear) ? "dd MMMM, HH:mm" : "dd MMMM yyyy, HH:mm"
        
        return formatter.string(from: date)
    }
}
