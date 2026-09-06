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
    
    init(ride: Ride) {
        self.ride = ride
        _rideName = State(initialValue: ride.title)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SharedMapView(isInteractive: false, routeCoordinates: ride.routeCoordinates, showMarkers: true)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 8) {
                    if editingTitle {
                        TextField("Ride Title", text: $rideName)
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
                  
                    Text(ride.date, format: .dateTime.weekday(.wide).day().month().year().hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                .onChange(of: titleFocused) {
                    if !titleFocused {
                        editingTitle = false
                        ride.title = rideName
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
