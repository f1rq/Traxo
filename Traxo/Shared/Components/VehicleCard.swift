//
//  VehicleCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 16/09/2026.
//

import SwiftUI
import SwiftData

struct VehicleCard: View {
    let vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(vehicle.fullName)
                        .font(.title2.bold())
                    
                    Text("\(String(vehicle.year))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Image(systemName: "motorcycle")
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .padding(.top, 12)
        
        
            Divider()
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Odometer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(vehicle.odometerKm)) km")
                        .font(.headline)
                }

                if let engine = vehicle.engineCapacityCc {
                    VStack(alignment: .leading) {
                        Text("Engine")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(engine) cc")
                            .font(.headline)
                    }
                }
                
                if let consumption = vehicle.fuelConsumptionL100km {
                    VStack(alignment: .leading) {
                        Text("Fuel Consmumption")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f L", consumption))
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    VehicleCard(vehicle: Vehicle(brand: "Honda", modelName: "Rebel", year: 2021, odometerKm: 12345, engineCapacityCc: 125, fuelConsumptionL100km: 3.5))
        
}
