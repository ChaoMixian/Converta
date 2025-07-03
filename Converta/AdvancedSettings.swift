// AdvancedSettings.swift
import SwiftUI

struct AdvancedSettings: View {
    @Binding var file: FileInfo
    @State private var showAdvanced = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 高级设置开关
            Button(action: {
                showAdvanced.toggle()
            }) {
                HStack {
                    Text("高级设置")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: showAdvanced ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showAdvanced {
                VStack(alignment: .leading, spacing: 12) {
                    // 预设选项
                    HStack(spacing: 8) {
                        PresetButton(title: "网页优化", icon: "globe") {
                            file.quality = 0.7
                            file.compressionLevel = 0.6
                        }
                        
                        PresetButton(title: "高质量", icon: "star") {
                            file.quality = 0.9
                            file.compressionLevel = 0.3
                        }
                        
                        PresetButton(title: "小文件", icon: "doc.circle") {
                            file.quality = 0.5
                            file.compressionLevel = 0.8
                        }
                    }
                    
                    // 尺寸设置（图片）
                    if file.type.conforms(to: .image) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("尺寸")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                TextField("宽度", value: $file.customWidth, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                
                                Text("×")
                                    .foregroundColor(.secondary)
                                
                                TextField("高度", value: $file.customHeight, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                
                                Button("重置") {
                                    file.customWidth = nil
                                    file.customHeight = nil
                                }
                                .font(.caption)
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}