//
//  SectionHeader.swift
//  Traxo
//
//  Created by Fabio Czudaj on 22/03/2026.
//
import SwiftUI

enum SectionHeaderAction {
    case textOnly
    case switchTab(Binding<Int>, to: Int)
    case navigate(AnyView)
    
    var isTextOnly: Bool {
        if case .textOnly = self {
            return true
        }
        return false
    }
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
            
        case .textOnly:
            headerContent
        }
    }
    
    var headerContent: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            if !action.isTextOnly {
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
        }
    }
}
