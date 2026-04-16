//
//  RecordView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import SwiftUI
import SwiftData
import MapKit

struct RecordView: View {
    let vm: RideViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showMap: Bool = true
    @State private var completedRide: Ride? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                SharedMapView(
                    isInteractive: true,
                    routeCoordinates: vm.locationManager.routeCoordinates
                )
                    .frame(height: 300)
                    .frame(height: showMap ? 300 : 0)
                    .opacity(showMap ? 1 : 0)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .animation(.easeInOut, value: showMap)
            
                
                VStack{
                    Text(vm.formattedTime)
                        .font(.system(size: 72))
                }
                HStack(spacing: 16) {
                    RideStatCard(label: "km", value: vm.formattedDistance)
                    RideStatCard(label: "km/h", value: vm.formattedSpeed)
                    RideStatCard(label: "max km/h", value: vm.formattedMaxSpeed)
                }
                
                switch vm.state {
                case .idle:
                    Button(action: { vm.start() }) {
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 86, height: 86)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                case .running:
                    HStack(spacing: 16) {
                        Button(action: {
                            if let ride = vm.stop() {
                                completedRide = ride
                                showMap = false
                            }
                        }) {
                            Image(systemName: "stop.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 64, height: 64)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                        
                        Button(action: { vm.pause() }) {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 86, height: 86)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                        }
                        
                        Button(action: { withAnimation { showMap.toggle() } }) {
                            Image(systemName: showMap ? "map.fill" : "map")
                                .foregroundStyle(.primary)
                                .frame(width: 64, height: 64)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                    }
                case .paused:
                    HStack(spacing: 16) {
                        Button(action: {
                            if let ride = vm.stop() {
                                completedRide = ride
                                showMap = false
                            }
                        }) {
                            Image(systemName: "stop.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 64, height: 64)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                        
                        Button(action: { vm.start() }) {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 86, height: 86)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                        }
                        
                        Button(action: { withAnimation { showMap.toggle() } }) {
                            Image(systemName: showMap ? "map.fill" : "map")
                                .foregroundStyle(.primary)
                                .frame(width: 64, height: 64)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .sheet(item: $completedRide) { ride in
            RideSummaryView(ride: ride) {
                dismiss()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    RecordView(vm: RideViewModel())
}
