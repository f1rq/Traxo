//
//  ContentView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            RoutesView()
                .tabItem {
                    Label("Routes", systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath")
                }
                .tag(1)
            
            GarageView()
                .tabItem {
                    Label("Garage", systemImage: "door.garage.closed")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
