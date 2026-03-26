//
//  RidesView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI
import SwiftData

struct RidesView: View {
    @Query(sort: \Ride.date, order: .reverse)
    private var rides: [Ride]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(rides) { ride in
                    RideCard(ride: ride)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Your rides")
    }
}

#Preview {
    RidesView()
}
