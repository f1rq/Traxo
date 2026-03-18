//
//  BikeDetailView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 18/03/2026.
//

import SwiftUI

struct BikeDetailView: View {
    let name: String
    let desc: String
    
    var body: some View {
        Text(name)
            .navigationTitle(name)
    }
}
