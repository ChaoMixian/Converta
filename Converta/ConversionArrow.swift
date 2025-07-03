// ConversionArrow.swift
import SwiftUI

struct ConversionArrow: View {
    let isConverting: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "arrow.right")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.accentColor)
                .rotationEffect(.degrees(isConverting ? 360 : 0))
                .animation(isConverting ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: isConverting)
            
            if isConverting {
                Text("转换中")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 80, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.1))
        )
    }
}