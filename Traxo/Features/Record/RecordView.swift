//
//  RecordView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//

import SwiftUI

struct RecordView: View {
    @State private var vm = RideViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                Text(vm.formattedTime)
                    .font(.system(size: 72))
                
                
                HStack(spacing: 16) {
                    StatsCard(type: .distance, value: 0.0)
                    StatsCard(type: .speed, value: 0)
                    StatsCard(type: .maxSpeed, value: 0)
                }
                
                Button(action: {
                    vm.isRunning ? vm.stop(): vm.start()
                }) {
                    Image(systemName: vm.isRunning ? "stop.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .frame(width: 76, height: 76)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RecordView()
}
