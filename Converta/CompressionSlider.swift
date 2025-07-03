//
//  CompressionSlider.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// CompressionSlider.swift
import SwiftUI

struct CompressionSlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("无")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Slider(value: $value, in: 0.0...1.0, step: 0.1)
                    .accentColor(.accentColor)
                
                Text("最大")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(compressionText)
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var compressionText: String {
        switch value {
        case 0.0...0.2:
            return "无压缩"
        case 0.2...0.4:
            return "轻度压缩"
        case 0.4...0.6:
            return "中度压缩"
        case 0.6...0.8:
            return "高度压缩"
        default:
            return "最大压缩"
        }
    }
}