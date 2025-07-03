//
//  FileCard.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// FileCard.swift
import SwiftUI

struct FileCard: View {
    @State var file: FileInfo
    let isEditable: Bool
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 卡片标题
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            // 文件信息
            VStack(alignment: .leading, spacing: 12) {
                // 文件图标和名称
                HStack(spacing: 12) {
                    Image(systemName: file.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(file.name)
                            .font(.body)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        Text(file.formattedSize)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                // 格式选择
                VStack(alignment: .leading, spacing: 8) {
                    Text("格式")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if isEditable {
                        FormatPicker(selectedFormat: $file.format, availableFormats: file.availableFormats)
                    } else {
                        Text(file.format.uppercased())
                            .font(.body)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                // 质量设置（如果可编辑且为图片/视频）
                if isEditable && (file.type.conforms(to: .image) || file.type.conforms(to: .movie)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("质量")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        QualitySlider(value: $file.quality)
                    }
                }
                
                // 压缩设置
                if isEditable {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("压缩")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        CompressionSlider(value: $file.compressionLevel)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
