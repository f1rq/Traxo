//
//  RideView.swift
//  Traxo
//
//  Created by Fabio Czudaj on 19/03/2026.
//

import SwiftUI

struct RideView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .navigationTitle(name)
    }
}
