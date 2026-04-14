//
//  RideStatCard.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//
// Swift
import SwiftUI

struct RideStatCard: View {
    let label: String
    let value: String
    var width: CGFloat? = nil
    private let height: CGFloat = 80

    var body: some View {
        let content = VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22))
                .fontWeight(.semibold)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }

        Group {
            if let width = width {
                content.frame(width: width, height: height)
            } else {
                content.frame(maxWidth: .infinity, minHeight: height)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}
