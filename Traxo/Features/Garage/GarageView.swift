//
//  GarageView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 17/03/2026.
//
import SwiftUI
import SwiftData

struct GarageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.brand) private var vehicles: [Vehicle]
    
    @State private var showingAddVehicle = false

    var body: some View {
        NavigationStack {
            Group {
                if vehicles.isEmpty {
                    ContentUnavailableView(
                        "No Vehicles in Garage",
                        systemImage: "gauge.with.dots.needle.bottom.50percent",
                        description: Text("Add your vehicle to start tracking stats.")
                    )
                } else {
                    List {
                        ForEach(vehicles) { vehicle in
                            VehicleCard(vehicle: vehicle)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                        }
                        .onDelete(perform: deleteVehicles)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Garage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddVehicle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddVehicle) {
                AddVehicleView()
            }
        }
    }
    
    private func deleteVehicles(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(vehicles[index])
        }
    }
}

#Preview {
    GarageView()
}
