//
//  MiniRideCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI

struct MiniRideCard: View {
    let name: String
    let desc: String
    
    var body: some View {
        NavigationLink(destination: RideView(name: name, desc: desc)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
                Text(desc)
                    .font(.caption)
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

#Preview {
    MiniRideCard(name: "87 km", desc: "Mar 14 - 1h 32m")
}
