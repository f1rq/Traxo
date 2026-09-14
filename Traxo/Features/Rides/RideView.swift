//
//  RideView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI

import SwiftUI
import MapKit

struct RideView: View {
    let ride: Ride

    @State private var editingTitle = false
    @State private var rideName: String
    @FocusState private var titleFocused: Bool
    
    @State private var editingDesc = false
    @State private var rideDesc: String
    @FocusState private var descFocused: Bool
    
    init(ride: Ride) {
        self.ride = ride
        _rideName = State(initialValue: ride.title)
        _rideDesc = State(initialValue: ride.desc)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SharedMapView(isInteractive: false, routeCoordinates: ride.routeCoordinates, showMarkers: true)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 8) {
                    Text(ride.date, format: .dateTime.weekday(.wide).day().month().year().hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 4) { // Title and desc group
                        if editingTitle {
                            TextField("Untitled ride", text: $rideName)
                                .font(.title.bold())
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
                                .font(.title.bold())
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
                                .foregroundStyle(ride.desc.isEmpty ? .secondary : .primary)
                                .onTapGesture {
                                    editingDesc = true
                                }
                        }
                    }

                }
                
                .onChange(of: titleFocused) {
                    if !titleFocused {
                        editingTitle = false
                        ride.title = rideName
                    }
                }
                .onChange(of: descFocused) {
                    if !descFocused {
                        editingDesc = false
                        ride.desc = rideDesc
                    }
                }
                
                HStack(spacing: 16) {
                    RideStatCard(label: "distance", value: ride.formattedDistance)
                    RideStatCard(label: "duration", value: ride.formattedDuration)
                }

                HStack(spacing: 16) {
                    RideStatCard(label: "max speed", value: ride.formattedMaxSpeed)
                    RideStatCard(label: "avg speed", value: ride.formattedAvgSpeed)
                }
            }
            .padding()
        }
        .navigationTitle("Ride")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RideView(ride: Ride(distance: 10, duration: 3600, date: Date(), maxSpeed: 25, avgSpeed: 15, desc: "test"))
}
