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
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                Map(position: $position)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack{
                    Text(vm.formattedTime)
                        .font(.system(size: 72))
                }
                HStack(spacing: 16) {
                    RideStatCard(type: .distance, value: vm.locationManager.totalDistance / 1000)
                    RideStatCard(type: .speed, value: vm.locationManager.currentSpeed * 3.6)
                    RideStatCard(type: .maxSpeed, value: vm.locationManager.maxSpeed * 3.6)
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
                                context.insert(ride)
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
                        
                        Button(action: {}) {
                            Image(systemName: "mappin")
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
                                context.insert(ride)
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
                        
                        Button(action: {}) {
                            Image(systemName: "mappin")
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
    }
}

#Preview {
    RecordView(vm: RideViewModel())
}
