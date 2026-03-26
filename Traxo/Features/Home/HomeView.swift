//
//  HomeView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var selectedTab: Int
    let vm: RideViewModel
    @Binding var showRecordSheet: Bool
    
    @Query(sort: \Ride.date, order: .reverse)
    private var rides: [Ride]
    
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
                    
                    StartRideCard(vm: vm, showSheet: $showRecordSheet)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Your garage", action: .switchTab($selectedTab, to: 2))
                        
                        HomeBikeCard(name: "Honda Rebel 125", desc: "Last ride: 3 days ago", descType: "normal")
                        HomeBikeCard(name: "BMW S1000RR", desc: "Oil change due", descType: "warning")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Recent rides", action: .navigate(AnyView(RidesView())))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(rides.prefix(5)) { ride in
                                    MiniRideCard(ride: ride)
                                }
                            }
                        }
                    }
                    
                    NavigationLink(destination: DebugRidesView()) {
                        Text("Debug Rides")
                    }
                    .background(Color.red.opacity(0.1))
                }
                .padding(.horizontal)
            }
        }
    }
}

struct StartRideCard: View {
    let vm: RideViewModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: { showSheet = true }) {
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
    HomeView(selectedTab: .constant(0), vm: RideViewModel(), showRecordSheet: .constant(false))
}
