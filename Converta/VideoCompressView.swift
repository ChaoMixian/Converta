// MARK: - Views/VideoCompressView.swift
import SwiftUI
import UniformTypeIdentifiers

struct VideoCompressView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFiles: [URL] = []
    @State private var compressionLevel: Double = 50
    @State private var outputFormat: String = "mp4"
    @State private var status: ProcessingStatus = .idle
    
    private let videoFormats = ["mp4", "mov", "avi", "mkv"]
    
    var body: some View {
        VStack(spacing: 20) {
            if selectedFiles.isEmpty {
                FileDropZone(
                    title: "视频压缩",
                    acceptedTypes: [.movie, .video]
                ) { files in
                    selectedFiles = files
                }
            } else {
                VStack(spacing: 16) {
                    // 文件列表
                    GroupBox("已选择文件") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(selectedFiles, id: \.self) { file in
                                HStack {
                                    Image(systemName: "video")
                                        .foregroundColor(.accentColor)
                                    Text(file.lastPathComponent)
                                        .font(.system(.body, design: .monospaced))
                                    Spacer()
                                    Button(action: {
                                        selectedFiles.removeAll { $0 == file }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // 压缩设置
                    GroupBox("压缩设置") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("压缩级别:")
                                Slider(value: $compressionLevel, in: 1...100)
                                Text("\(Int(compressionLevel))%")
                                    .frame(width: 40)
                            }
                            
                            HStack {
                                Text("输出格式:")
                                Picker("", selection: $outputFormat) {
                                    ForEach(videoFormats, id: \.self) { format in
                                        Text(format.uppercased()).tag(format)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        .padding()
                    }
                    
                    // 操作按钮
                    HStack {
                        Button("清空") {
                            selectedFiles.removeAll()
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("开始压缩") {
                            startCompression()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(status == .processing)
                    }
                    
                    // 状态显示
                    if case .processing = status {
                        ProgressView("正在压缩...")
                            .progressViewStyle(LinearProgressViewStyle())
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // 处理从其他地方传入的文件
            if !appState.incomingFiles.isEmpty {
                let videoFiles = appState.incomingFiles.filter { file in
                    let ext = file.pathExtension.lowercased()
                    return ["mp4", "mov", "avi", "mkv", "wmv", "flv", "webm"].contains(ext)
                }
                selectedFiles.append(contentsOf: videoFiles)
                appState.incomingFiles.removeAll()
            }
        }
    }
    
    private func startCompression() {
        status = .processing
        // 这里添加实际的压缩逻辑
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            status = .completed
        }
    }
}