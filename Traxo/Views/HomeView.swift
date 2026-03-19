//
//  HomeView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//
import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    
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
                        SectionHeader(title: "Your garage", action: .switchTab($selectedTab, to: 2))
                        
                        HomeBikeCard(name: "Honda Rebel 125", desc: "Last ride: 3 days ago", descType: "normal")
                        HomeBikeCard(name: "BMW S1000RR", desc: "Oil change due", descType: "warning")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Recent rides", action: .navigate(AnyView(RidesView())))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                HomeRidesCard(name: "87 km", desc: "Mar 14 - 1h 32m")
                                HomeRidesCard(name: "124 km", desc: "Mar 10 - 2h 15m")
                                HomeRidesCard(name: "43 km", desc: "Mar 06 - 45m")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

enum SectionHeaderAction {
    case switchTab(Binding<Int>, to: Int)
    case navigate(AnyView)
}

struct SectionHeader: View {
    let title: String
    let action: SectionHeaderAction
    
    var body: some View {
        switch action {
        case .switchTab(let binding, let index):
            Button(action: { binding.wrappedValue = index}) {
                headerContent
            }
            .buttonStyle(.plain)
            
        case .navigate(let destination):
            NavigationLink(destination: destination) {
                headerContent
            }
            .buttonStyle(.plain)
        }
    }
    
    var headerContent: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
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
    HomeView(selectedTab: .constant(0))
}
