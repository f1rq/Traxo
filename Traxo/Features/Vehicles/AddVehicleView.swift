//
//  AddVehicleView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 16/09/2026.
//

import SwiftUI
import SwiftData

struct AddVehicleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var brand: String = ""
    @State private var modelName: String = ""
    @State private var yearString: String = ""
    @State private var odometerString: String = ""
    @State private var engineCapacityString: String = ""
    @State private var fuelTankCapacityString: String = ""
    @State private var fuelConsumptionString: String = ""
    
    var isValid: Bool {
        !brand.trimmingCharacters(in: .whitespaces).isEmpty &&
        !modelName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !yearString.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Vehicle Info (Required)") {
                    TextField("Brand (e.g., Honda)", text: $brand)
                    TextField("Model (e.g., CBR500R)", text: $modelName)
                    HStack {
                        Text("Year")
                        Spacer()
                        TextField("2000", text: $yearString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Details (Optional)") {
                    HStack {
                        Text("Odometer (km)")
                        Spacer()
                        TextField("25000", text: $odometerString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Engine (cc)")
                        Spacer()
                        TextField("125", text: $engineCapacityString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Fuel Stats (Optional)") {
                    HStack {
                        Text("Tank Capacity (L)")
                        Spacer()
                        TextField("10.0", text: $fuelTankCapacityString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Consump. (L/100km)")
                        Spacer()
                        TextField("3.2", text: $fuelConsumptionString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Add Vehicle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveVehicle()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveVehicle() {
        let year = Int(yearString) ?? Calendar.current.component(.year, from: Date())
        let odometer = Double(odometerString.replacingOccurrences(of: ",", with: ".")) ?? 0
        let engine = Int(engineCapacityString)
        let tank = Double(fuelTankCapacityString.replacingOccurrences(of: ",", with: "."))
        let consumption = Double(fuelConsumptionString.replacingOccurrences(of: ",", with: "."))
        
        let newVehicle = Vehicle(
            brand: brand.trimmingCharacters(in: .whitespaces),
            modelName: modelName.trimmingCharacters(in: .whitespaces),
            year: year,
            odometerKm: odometer,
            engineCapacityCc: engine,
            fuelTankCapacityLiters: tank,
            fuelConsumptionL100km: consumption
        )
        
        modelContext.insert(newVehicle)
        dismiss()
    }
}

#Preview {
    AddVehicleView()
}
