//
//  SettingsView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @State private var outputDirectory: String = "~/Downloads"
    @State private var keepOriginalFiles: Bool = true
    @State private var autoOpenResults: Bool = false
    @State private var enableFinderExtension: Bool = false
    
    var body: some View {
        Form {
            Section("输出设置") {
                HStack {
                    Text("输出目录:")
                    TextField("", text: $outputDirectory)
                    Button("选择") {
                        selectOutputDirectory()
                    }
                }
                
                Toggle("保留原始文件", isOn: $keepOriginalFiles)
                Toggle("自动打开结果", isOn: $autoOpenResults)
            }
            
            Section("系统集成") {
                Toggle("启用 Finder 扩展", isOn: $enableFinderExtension)
                    .help("在 Finder 工具栏中显示 Converta 按钮")
            }
            
            Section("应用信息") {
                HStack {
                    Text("版本:")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("构建:")
                    Spacer()
                    Text("2024.001")
                        .foregroundColor(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    private func selectOutputDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            outputDirectory = panel.url?.path ?? outputDirectory
        }
    }
}