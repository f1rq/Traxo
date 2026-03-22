//
//  SectionHeader.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//
import SwiftUI

enum SectionHeaderAction {
    case switchTab(Binding<Int>, to: Int)
    case navigate(AnyView)
}

struct SectionHeader: View {
    let title: String
    let action: SectionHeaderAction
    
    var body: some View {
        switch action {
        case .switchTab(let binding, let index):
            Button(action: { binding.wrappedValue = index}) {
                headerContent
            }
            .buttonStyle(.plain)
            
        case .navigate(let destination):
            NavigationLink(destination: destination) {
                headerContent
            }
            .buttonStyle(.plain)
        }
    }
    
    var headerContent: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
    }
}
