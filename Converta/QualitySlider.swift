// QualitySlider.swift
import SwiftUI

struct QualitySlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("低")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Slider(value: $value, in: 0.1...1.0, step: 0.1)
                    .accentColor(.accentColor)
                
                Text("高")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text("\(Int(value * 100))%")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
