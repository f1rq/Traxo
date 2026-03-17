//
//  ContentView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            RoutesView()
                .tabItem {
                    Label("Routes", systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath")
                }
            
            GarageView()
                .tabItem {
                    Label("Garage", systemImage: "door.garage.closed")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
