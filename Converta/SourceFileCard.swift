// MARK: - SourceFileCard.swift
import SwiftUI

struct SourceFileCard: View {
    let file: ConvertaFile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 文件图标和基本信息
            HStack {
                Image(systemName: file.type.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(file.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(file.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 文件详细信息
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "大小", value: ByteCountFormatter.string(fromByteCount: Int64(file.size), countStyle: .file))
                InfoRow(label: "路径", value: file.url.path)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            
            Text(value)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
