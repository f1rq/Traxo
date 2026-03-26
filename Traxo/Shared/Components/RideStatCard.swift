//
//  RideStatCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//
import SwiftUI

enum StatType {
    case distance
    case speed
    case maxSpeed
    
    var label: String {
        switch self {
        case .distance: return "km"
        case .speed:    return "km/h"
        case .maxSpeed: return "max km/h"
        }
    }
}

struct RideStatCard: View {
    let type: StatType
    let value: Double
    
    var formattedValue: String {
        switch type {
        case .distance: return String(format: "%.1f", value)
        case .speed, .maxSpeed: return String(format: "%.0f", value)
        }
    }
    
    var body: some View {
        VStack() {
            Text(formattedValue)
                .font(.system(size: 22))
                .fontWeight(.semibold)
            Text(type.label)
                .font(.system(size: 14))
        }
        .frame(width: 110, height: 80)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}
