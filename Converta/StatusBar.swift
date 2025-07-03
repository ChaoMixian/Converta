//
//  StatusBar.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// StatusBar.swift
import SwiftUI

struct StatusBar: View {
    let message: String
    let type: StatusType
    
    enum StatusType {
        case info, success, warning, error
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .info: return "info.circle"
            case .success: return "checkmark.circle"
            case .warning: return "exclamationmark.triangle"
            case .error: return "xmark.circle"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: type.icon)
                .foregroundColor(type.color)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(type.color.opacity(0.1))
        .cornerRadius(6)
    }
}