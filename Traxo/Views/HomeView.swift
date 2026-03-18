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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Your garage")
                        
                        BikeCard(name: "Honda Rebel 125", desc: "Last ride: 3 days ago")
                        BikeCard(name: "BMW S1000RR", desc: "Oil change due")
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
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
                Image(systemName: "play.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
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
