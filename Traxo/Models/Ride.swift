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
    var distance: Double
    var duration: Int
    var date: Date
    
    init(distance: Double, duration: Int, date: Date) {
        self.distance = distance
        self.duration = duration
        self.date = date
    }
}
