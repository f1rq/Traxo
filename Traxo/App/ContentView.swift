//
//  ContentView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var vm = RideViewModel()
    @State private var showRecordSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab, vm: vm, showRecordSheet: $showRecordSheet)
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
            
            if vm.state != .idle {
                RideStatusBar(vm: vm, showSheet: $showRecordSheet)
                    .padding(.horizontal)
                    .padding(.bottom, 59)
            }
        }
        .sheet(isPresented: $showRecordSheet) {
            RecordView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
