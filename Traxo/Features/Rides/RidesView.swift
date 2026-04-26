//
//  RidesView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI
import SwiftData

struct RidesView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Ride.date, order: .reverse)
    private var rides: [Ride]

    var body: some View {
        NavigationStack {
            List {
                ForEach(rides) { ride in
                    ZStack {
                        NavigationLink(destination: RideView(ride: ride)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        RideCard(ride: ride)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            modelContext.delete(ride)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Your rides")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
