//
//  MiniRidePlayer.swift
//  Traxo
//
//  Created by Fabio Czudaj on 24/03/2026.
//

import SwiftUI

struct MiniRidePlayer: View {
    let vm: RideViewModel
    @Binding var showSheet: Bool
    @State private var animationRotation: Double = 0
    @Environment(\.scenePhase) private var scenePhase
    @State private var borderRefreshID: Int = 0
    
    var body: some View {
        Button(action: { showSheet = true }) {
            ZStack {
                HStack(spacing: 16) {
                    HStack {
                        Text(vm.state == .running ? "Recording" : "Paused")
                            .foregroundStyle(.primary)
                        Spacer(minLength: 0)
                    }
                    .frame(width: 96)

                    Text(vm.formattedTime)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.primary)

                    HStack {
                        Spacer(minLength: 0)
                        Button(action: { vm.state == .running ? vm.pause() : vm.start() }) {
                            Image(systemName: vm.state == .running ? "pause.fill" : "play.fill")
                        }
                        .foregroundStyle(.primary)
                    }
                    .frame(width: 96)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .contentShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    AnimatedLiquidBorder(cornerRadius: 24, isRunning: vm.state == .running)
                        .id(borderRefreshID)
                        .drawingGroup()
                )
            }
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
            .buttonStyle(.plain)
        }
        .onChange(of: showSheet) { oldValue, newValue in
            if oldValue == true && newValue == false {
                borderRefreshID &+= 1
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                borderRefreshID &+= 1
            }
        }
    }
}

private struct AnimatedLiquidBorder: View {
    let cornerRadius: CGFloat
    let isRunning: Bool
    @State private var phase: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor.opacity(0.95),
                        Color.accentColor.opacity(0.25),
                        Color.accentColor.opacity(0.0),
                        Color.accentColor.opacity(0.25),
                        Color.accentColor.opacity(0.95)
                    ]),
                    center: .center,
                    angle: .degrees(phase)
                ),
                lineWidth: 2
            )
            .blendMode(.plusLighter)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .inset(by: 1)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color.accentColor.opacity(0.0),
                                Color.accentColor.opacity(0.45),
                                Color.accentColor.opacity(0.0)
                            ]),
                            center: .center,
                            angle: .degrees(phase + 90)
                        ),
                        lineWidth: 1
                    )
                    .blur(radius: 0.8)
                    .opacity(0.8)
                    .shadow(color: Color.accentColor.opacity(0.35), radius: 6, x: 0, y: 0)
            )
            .allowsHitTesting(false)
            .onAppear {
                if isRunning {
                    phase = 0
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        phase = 360
                    }
                }
            }
            .onChange(of: isRunning) { oldValue, newValue in
                if newValue {                    phase = 0
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        phase = 360
                    }
                } else {
                    withAnimation(.none) {
                        phase = phase
                    }
                }
            }
    }
}

#Preview {
    MiniRidePlayer(vm: RideViewModel(), showSheet: .constant(true))
}
