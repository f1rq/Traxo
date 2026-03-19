//
//  HomeBikeCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 18/03/2026.
//

import SwiftUI

struct HomeBikeCard: View {
    let name: String
    let desc: String
    let descType: String
    
    var body: some View {
        NavigationLink(destination: BikeDetailView(name: name, desc: desc)) {
            HStack(spacing: 14) {
                Image(systemName: "motorcycle")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.primary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text(desc)
                        .font(.subheadline)
                        .foregroundStyle(descType == "warning" ? .red : .primary.opacity(0.8))
                }
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

#Preview {
    HomeBikeCard(name: "Honda Rebel 125", desc: "Last ride: 3 days ago", descType: "normal")
}
