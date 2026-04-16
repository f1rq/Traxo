//
//  Ride.swift
//  Traxo
//
//  Created by Fabio Czudaj on 26/03/2026.
//

import SwiftData
import Foundation
import CoreLocation

@Model
class Ride {
    var title: String
    var distance: Double
    var duration: Int
    var date: Date
    var maxSpeed: Double
    var avgSpeed: Double
    var rideLatitudes: [Double]
    var rideLongitudes: [Double]
    
    init(distance: Double, duration: Int, date: Date, maxSpeed: Double, avgSpeed: Double, rideLatitudes: [Double] = [], rideLongitudes: [Double] = []) {
        self.title = "Untitled ride"
        self.distance = distance
        self.duration = duration
        self.date = date
        self.maxSpeed = maxSpeed
        self.avgSpeed = avgSpeed
        self.rideLatitudes = rideLatitudes
        self.rideLongitudes = rideLongitudes
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
    
    var shortFormattedDate: String {
        let calendar = Calendar.current
        let rideYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = (rideYear == currentYear) ? "dd MMM, HH:mm" : "dd MMM yyyy, HH:mm"
        
        return formatter.string(from: date)
    }
    
    var formattedMaxSpeed: String {
        String(format: "%.0f", maxSpeed) + " km/h"
    }
    
    var formattedAvgSpeed: String {
        String(format: "%.0f", avgSpeed) + " km/h"
    }
    
    var routeCoordinates: [CLLocationCoordinate2D] {
        zip(rideLatitudes, rideLongitudes).map {
            CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1)
        }
    }
}
