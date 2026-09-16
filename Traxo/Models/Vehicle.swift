//
//  Vehicle.swift
//  Traxo
//
//  Created by Fabio Czudaj on 16/09/2026.
//

import SwiftData
import Foundation

@Model
class Vehicle {
    var brand: String
    var modelName: String
    var year: Int
    var odometerKm: Double
    var engineCapacityCc: Int?
    var fuelTankCapacityLiters: Double?
    var fuelConsumptionL100km: Double?
    
    @Relationship(deleteRule: .nullify, inverse: \Ride.vehicle)
    var rides: [Ride]?
    
    init(
        brand: String,
        modelName: String,
        year: Int,
        odometerKm: Double = 0,
        engineCapacityCc: Int? = nil,
        fuelTankCapacityLiters: Double? = nil,
        fuelConsumptionL100km: Double? = nil
    ) {
        self.brand = brand
        self.modelName = modelName
        self.year = year
        self.odometerKm = odometerKm
        self.engineCapacityCc = engineCapacityCc
        self.fuelTankCapacityLiters = fuelTankCapacityLiters
        self.fuelConsumptionL100km = fuelConsumptionL100km
        self.rides = []
    }
    
    var fullName: String {
        "\(brand) \(modelName)"
    }
}
