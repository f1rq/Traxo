//
//  RecordView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import SwiftUI

struct RecordView: View {
    let vm: RideViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                VStack{
                    Text(vm.formattedTime)
                        .font(.system(size: 72))
                }
                HStack(spacing: 16) {
                    StatsCard(type: .distance, value: 0.0)
                    StatsCard(type: .speed, value: 0)
                    StatsCard(type: .maxSpeed, value: 0)
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
                        Button(action: { vm.stop() }) {
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
                        Button(action: { vm.stop() }) {
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
