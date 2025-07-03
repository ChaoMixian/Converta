//
//  QuickAccessCard.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - Components/QuickAccessCard.swift
import SwiftUI

struct QuickAccessCard: View {
    let item: SidebarItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.accentColor)
                
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .help(item.title)
    }
}
