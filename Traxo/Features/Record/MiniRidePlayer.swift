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
        HStack(spacing: 16) {
            Image(systemName: "motorcycle")
            
            Text(vm.formattedTime)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            Button(action: { vm.state == .running ? vm.pause() : vm.start() }) {
                Image(systemName: vm.state == .running ? "pause.fill" : "play.fill")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
        .onTapGesture { showSheet = true }
    }
}

#Preview {
    MiniRidePlayer(vm: RideViewModel(), showSheet: .constant(true))
}
