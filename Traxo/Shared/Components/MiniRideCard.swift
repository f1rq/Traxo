//
//  MiniRideCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI

struct MiniRideCard: View {
    let ride: Ride
    
    var body: some View {
        NavigationLink(destination: RideView(ride: ride)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ride.title)
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(ride.formattedDistance)
                    .font(.subheadline)
                Text(ride.shortFormattedDate)
                    .font(.subheadline)
            }
            .frame(width: 120, alignment: .leading)
            .padding()
        }
        .buttonStyle(.plain)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}
