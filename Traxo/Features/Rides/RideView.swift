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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SharedMapView(isInteractive: false, routeCoordinates: ride.routeCoordinates)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 8) {
                    Text(ride.title.isEmpty ? "Untitled ride" : ride.title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text(ride.date, format: .dateTime.weekday(.wide).day().month().year().hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
