//
//  HomeView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Good morning, user!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    
                    StartRideCard()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct StartRideCard: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ready to ride?")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("Start a new ride")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "motorcycle")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.primary.opacity(0.3))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HomeView()
}
