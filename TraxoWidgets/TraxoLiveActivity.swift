//
//  TraxoLiveActivity.swift
//  Traxo
//
//  Created by Fabio Czudaj on 15/09/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TraxoLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TraxoActivityAttributes.self) { context in
            // Lock screen / Banner UI
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(context.state.isPaused ? Color.orange : Color.green)
                            .frame(width: 8, height: 8)
                        Text(context.state.isPaused ? "PAUSED" : "RECORDING")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.secondary)
                    }
                    Text(formatTime(context.state.elapsedSeconds))
                        .font(.system(size: 28, weight: .semibold, design: .monospaced))
                    
                    HStack(spacing: 6) {
                        Image("AppLogo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                        Text("Traxo")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(context.state.distanceKm, specifier: "%.1f") km")
                        .font(.system(size: 22, weight: .bold))
                    Text("\(Int(context.state.currentSpeedKmh)) km/h")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            // DynamicIsland UI
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(context.state.isPaused ? Color.orange : Color.green)
                                .frame(width: 6, height: 6)
                            Text(context.state.isPaused ? "PAUSED" : "RECORDING")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                        Text(formatTime(context.state.elapsedSeconds))
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        HStack(spacing: 6) {
                            Image("AppLogo")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                            Text("Traxo")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.top, 2)
                    }
                    .padding(.leading, 8)
                    .padding(.top, 6)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(context.state.distanceKm, specifier: "%.1f") km")
                            .font(.system(size: 18, weight: .bold))
                        
                        Text("\(Int(context.state.currentSpeedKmh)) km/h")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing, 8)
                    .padding(.top, 6)
                }
                
            } compactLeading: {
                Image("AppLogo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } compactTrailing: {
                Text("\(context.state.distanceKm, specifier: "%.1f") km")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            } minimal: {
                Image("AppLogo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

#Preview("Dynamic Island", as: .dynamicIsland(.expanded), using: TraxoActivityAttributes(startDate: Date())) {
   TraxoLiveActivity()
} contentStates: {
    TraxoActivityAttributes.ContentState(
        distanceKm: 14.2,
        currentSpeedKmh: 78,
        elapsedSeconds: 1245,
        isPaused: false
    )
    
    TraxoActivityAttributes.ContentState(
        distanceKm: 22.0,
        currentSpeedKmh: 0,
        elapsedSeconds: 2100,
        isPaused: true
    )
}

#Preview("Compact Dynamic Island", as: .dynamicIsland(.compact), using: TraxoActivityAttributes(startDate: Date())) {
   TraxoLiveActivity()
} contentStates: {
    TraxoActivityAttributes.ContentState(
        distanceKm: 14.2,
        currentSpeedKmh: 78,
        elapsedSeconds: 1245,
        isPaused: false
    )
    
    TraxoActivityAttributes.ContentState(
        distanceKm: 22.0,
        currentSpeedKmh: 0,
        elapsedSeconds: 2100,
        isPaused: true
    )
}

#Preview("Lock Screen", as: .content, using: TraxoActivityAttributes(startDate: Date())) {
   TraxoLiveActivity()
} contentStates: {
    TraxoActivityAttributes.ContentState(
        distanceKm: 14.2,
        currentSpeedKmh: 78,
        elapsedSeconds: 1245,
        isPaused: false
    )
}
