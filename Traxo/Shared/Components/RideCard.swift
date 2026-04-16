//
//  RideCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 26/03/2026.
//

import SwiftUI

struct RideCard: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(ride.title)
                    .font(.title)
                Spacer()
                Text(ride.formattedDistance)
                    .font(.title2)
                    .bold()
            }
            HStack {
                Text(ride.formattedDate)
                    .font(.subheadline)
                Spacer()
                Text(ride.formattedDuration)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}
