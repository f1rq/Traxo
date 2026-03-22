//
//  RecordView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import SwiftUI

struct RecordView: View {
    @State private var vm = RideViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                Text(vm.formattedTime)
                    .font(.system(size: 72))
                
                
                HStack(spacing: 16) {
                    StatsCard(type: .distance, value: 0.0)
                    StatsCard(type: .speed, value: 0)
                    StatsCard(type: .maxSpeed, value: 0)
                }
                
                Button(action: {
                    vm.isRunning ? vm.stop(): vm.start()
                }) {
                    Image(systemName: vm.isRunning ? "stop.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .frame(width: 76, height: 76)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
    }
}


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

struct StatsCard: View {
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

#Preview {
    RecordView()
}
