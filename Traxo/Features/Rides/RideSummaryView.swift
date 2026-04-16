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
    let ride: Ride
    var onCompletion: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var rideName: String = ""
    @FocusState private var titleFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.accentColor)

                    Text(ride.date, format: .dateTime.weekday(.wide).day().month().hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("Untitled ride", text: $rideName)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .focused($titleFocused)
                }
                .padding(.top)
                
                SharedMapView(isInteractive: false, routeCoordinates: ride.routeCoordinates)
                    .frame(height: 300)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                HStack(spacing: 16) {
                    RideStatCard(label: "distance", value: ride.formattedDistance)
                    RideStatCard(label: "duration", value: ride.formattedDuration)
                }

                HStack(spacing: 16) {
                    RideStatCard(label: "max speed", value: ride.formattedMaxSpeed)
                    RideStatCard(label: "avg speed", value: ride.formattedAvgSpeed)
                }

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
                        ride.title = rideName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Untitled ride"
                            : rideName
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
        }
        .scrollDismissesKeyboard(.interactively)
        .presentationDetents([.large])
        .interactiveDismissDisabled()
        .onAppear {
            rideName = ride.title
        }
    }
}

struct TitleTextField: View {
    @Binding var finalName: String
    @State private var draftName: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("Untitled ride", text: $draftName)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .onAppear {
                draftName = finalName
            }
            .onChange(of: isFocused) { _, focused in
                if !focused {
                    finalName = draftName
                }
            }
    }
}

#Preview {
    RideSummaryView(
        ride: Ride(distance: 42.5, duration: 3123, date: Date(), maxSpeed: 120, avgSpeed: 80),
        onCompletion: {}
    )
}
