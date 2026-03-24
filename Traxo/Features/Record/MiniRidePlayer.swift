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
    
    var body: some View {
        Button(action: { showSheet = true }) {
            HStack(spacing: 16) {
                Image(systemName: "motorcycle")
                
                Text(vm.formattedTime)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button(action: { vm.state == .running ? vm.pause() : vm.start() }) {
                    Image(systemName: vm.state == .running ? "pause.fill" : "play.fill")
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    MiniRidePlayer(vm: RideViewModel(), showSheet: .constant(true))
}
