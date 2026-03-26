//
//  DebugRidesView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 26/03/2026.
//

import SwiftUI
import SwiftData

struct DebugRidesView: View {
    @Query(sort: \Ride.date, order: .reverse)
    private var rides: [Ride]

    var body: some View {
        List {
            ForEach(rides) { ride in
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    TextField("Title", text: Binding(
                        get: { ride.title },
                        set: { ride.title = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)

                    // Duration (seconds)
                    HStack {
                        Text("Duration (s):")
                        TextField(
                            "",
                            text: Binding(
                                get: { String(ride.duration) },
                                set: { ride.duration = Int($0) ?? ride.duration }
                            )
                        )
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    }

                    // Date
                    DatePicker(
                        "Date",
                        selection: Binding(
                            get: { ride.date },
                            set: { ride.date = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                .padding(.vertical, 8)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let rideToDelete = rides[index]
                }
            }
        }
        .navigationTitle("Debug Rides")
    }
}
