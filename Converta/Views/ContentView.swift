//
//  ContentView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//
// MARK: - ContentView.swift

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var fileManager = FileConversionManager()
    @State private var isDragging = false
    
    var body: some View {
        HStack(spacing: 0) {
            // 左侧源文件区域
            if let sourceFile = fileManager.sourceFile {
                SourceFileCard(file: sourceFile)
                    .frame(maxWidth: .infinity)
            } else {
                DropZone(isDragging: $isDragging) { files in
                    fileManager.setSourceFile(files.first)
                }
                .frame(maxWidth: .infinity)
            }
            
            // 中间转换箭头
            if fileManager.sourceFile != nil {
                ConversionArrow(isConverting: fileManager.isConverting)
                    .frame(width: 60)
            }
            
            // 右侧目标文件区域
            if let sourceFile = fileManager.sourceFile {
                TargetFileCard(
                    sourceFile: sourceFile,
                    conversionSettings: $fileManager.conversionSettings,
                    onConvert: {
                        fileManager.convertFile()
                    },
                    onReset: {
                        fileManager.reset()
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .frame(minWidth: 800, minHeight: 400)
        .background(Color(NSColor.windowBackgroundColor))
        .alert("转换错误", isPresented: .constant(fileManager.errorMessage != nil)) {
            Button("确定") {
                fileManager.errorMessage = nil
            }
        } message: {
            Text(fileManager.errorMessage ?? "")
        }
    }
}

#Preview {
    ContentView()
}
