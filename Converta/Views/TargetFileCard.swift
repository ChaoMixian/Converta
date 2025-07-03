//
//  TargetFileCard.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - TargetFileCard.swift
import SwiftUI

struct TargetFileCard: View {
    let sourceFile: ConvertaFile
    @Binding var conversionSettings: ConversionSettings
    let onConvert: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 目标文件预览
            HStack {
                Image(systemName: sourceFile.type.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(getTargetFileName())
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text("转换后的\(sourceFile.type.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 转换参数设置
            ConversionSettingsView(
                fileType: sourceFile.type,
                settings: $conversionSettings
            )
            
            Spacer()
            
            // 操作按钮
            HStack {
                Button("重新选择") {
                    onReset()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("开始转换") {
                    onConvert()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func getTargetFileName() -> String {
        let baseName = sourceFile.url.deletingPathExtension().lastPathComponent
        let ext = getFileExtension(for: conversionSettings.targetFormat)
        return "\(baseName).\(ext)"
    }
    
    private func getFileExtension(for format: String) -> String {
        switch format.lowercased() {
        case "jpeg", "jpg": return "jpg"
        case "png": return "png"
        case "webp": return "webp"
        case "mp4": return "mp4"
        case "mov": return "mov"
        case "mp3": return "mp3"
        case "wav": return "wav"
        case "pdf": return "pdf"
        default: return "converted"
        }
    }
}