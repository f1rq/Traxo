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
    @State private var editingTitle = false
    @FocusState private var titleFocused: Bool
    
    @State private var rideDesc: String = ""
    @State private var editingDesc = false
    @FocusState private var descFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.accentColor)

                    Text(ride.date, format: .dateTime.weekday(.wide).day().month().hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 4) { // Title and desc group
                        if editingTitle {
                            TextField("Untitled ride", text: $rideName)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.plain)
                                .focused($titleFocused)
                                .onAppear {
                                    DispatchQueue.main.async {
                                        titleFocused = true
                                    }
                                }
                                .onSubmit {
                                    editingTitle = false
                                }
                        } else {
                            Text(rideName.isEmpty ? "Untitled ride" : rideName)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    editingTitle = true
                                }
                        }
                        
                        if editingDesc {
                            TextField("Ride Description", text: $rideDesc)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.plain)
                                .focused($descFocused)
                                .onAppear {
                                    DispatchQueue.main.async {
                                        descFocused = true
                                    }
                                }
                                .onSubmit {
                                    editingDesc = false
                                }
                        } else {
                            Text(rideDesc.isEmpty ? "Add description..." : rideDesc)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(rideDesc.isEmpty ? .secondary : .primary)
                                .onTapGesture {
                                    editingDesc = true
                                }
                        }
                    }
                    
                }
                .padding(.top)
                .onChange(of: titleFocused) {
                    if !titleFocused {
                        editingTitle =  false
                    }
                }
                .onChange(of: descFocused) {
                    if !descFocused {
                        editingDesc = false
                    }
                }
                
                SharedMapView(isInteractive: false, routeCoordinates: ride.routeCoordinates, showMarkers: true)
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
                        ride.desc = rideDesc
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
            rideDesc = ride.desc
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
        ride: Ride(distance: 42.5, duration: 3123, date: Date(), maxSpeed: 120, avgSpeed: 80, desc: "test"),
        onCompletion: {}
    )
    .modelContainer(for: Ride.self, inMemory: true)
}
