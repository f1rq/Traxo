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
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThickMaterial)
            )
            .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 24))
            .buttonStyle(.plain)
        }
        .onChange(of: showSheet) { oldValue, newValue in
            if oldValue == true && newValue == false {
                borderRefreshID &+= 1
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                borderRefreshID &+= 1
            }
        }
    }
}

private struct AnimatedLiquidBorder: View {
    let cornerRadius: CGFloat
    let isRunning: Bool

    private let period: TimeInterval = 5.0

    @State private var accumulated: TimeInterval = 0
    @State private var lastStart: Date? = nil

    var body: some View {
        TimelineView(.animation) { context in
            let now = context.date

            let effectiveElapsed: TimeInterval = {
                if isRunning, let lastStart {
                    return accumulated + now.timeIntervalSince(lastStart)
                } else {
                    return accumulated
                }
            }()

            let phase = (effectiveElapsed.truncatingRemainder(dividingBy: period) / period) * 360.0
            border(phase: phase)
        }
        .allowsHitTesting(false)
        .onAppear {
            if isRunning {
                lastStart = Date()
            }
        }
        .onChange(of: isRunning) { _, newValue in
            let now = Date()
            if newValue {
                lastStart = now
            } else {
                if let lastStart {
                    accumulated += now.timeIntervalSince(lastStart)
                }
                self.lastStart = nil
            }
        }
    }

    @ViewBuilder
    private func border(phase: Double) -> some View {
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
    }
}

#Preview {
    MiniRidePlayer(vm: RideViewModel(), showSheet: .constant(true))
}
