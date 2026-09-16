//
//  TraxoApp.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//

import SwiftUI
import SwiftData

@main
struct TraxoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Ride.self, Vehicle.self])
    }
}
