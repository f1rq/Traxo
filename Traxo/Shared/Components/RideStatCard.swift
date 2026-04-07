//
//  RideStatCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//
import SwiftUI

struct RideStatCard: View {
    let label: String
    let value: String
    var width: CGFloat = 110
        
    var body: some View {
        VStack() {
            Text(value)
                .font(.system(size: 22))
                .fontWeight(.semibold)
            Text(label)
                .font(.system(size: 14))
        }
        .frame(width: width, height: 80)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}
