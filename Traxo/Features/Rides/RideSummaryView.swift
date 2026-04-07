//
//  RideSummaryView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 06/04/2026.
//

import SwiftUI
import SwiftData
import MapKit

struct RideSummaryView: View {
    let vm: RideViewModel
    let ride: Ride
    var onCompletion: () -> Void
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var rideName: String = ""
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentColor)
                
                Text(ride.date, format: .dateTime.weekday(.wide).day().month().hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextField("Untitled ride", text: $rideName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
            }
            
            Map(position: $position)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .disabled(true)
                .transition(.opacity.combined(with: .scale))
            
            HStack(spacing: 16) {
                RideStatCard(label: "km", value: ride.formattedDistance)
                RideStatCard(label: "avg km/h", value: ride.formattedAvgSpeed)
                RideStatCard(label: "max km/h", value: ride.formattedMaxSpeed)
            }
            RideStatCard(label: "duration", value: ride.formattedDuration, width: 165)
            
            HStack(spacing: 12) {
                Button("Discard") {
                    context.delete(ride)
                    dismiss()
                    onCompletion()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                
                Button("Save") {
                    ride.title = rideName.isEmpty ? "Untitled ride" : rideName
                    context.insert(ride)
                    dismiss()
                    onCompletion()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.primary)
                .glassEffect(.regular.interactive().tint(.accentColor), in: RoundedRectangle(cornerRadius: 20))
            }
        }
        
        .padding()
        .presentationDetents([.large])
        .interactiveDismissDisabled()
    }
}

#Preview {
    RideSummaryView(
        vm: RideViewModel(), ride: Ride(distance: 42.5, duration: 3123, date: Date(), maxSpeed: 120, avgSpeed: 80),
        onCompletion: {}
    )
}
