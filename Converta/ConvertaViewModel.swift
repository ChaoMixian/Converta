// ConvertaViewModel.swift - 增强版本
import SwiftUI
import UniformTypeIdentifiers

class ConvertaViewModel: ObservableObject {
    @Published var sourceFile: FileInfo?
    @Published var targetFile: FileInfo?
    @Published var isConverting = false
    @Published var conversionProgress: Double = 0.0
    @Published var currentTask: String = ""
    @Published var statusMessage: String?
    @Published var statusType: StatusBar.StatusType = .info
    
    // 批量转换支持
    @Published var sourceFiles: [FileInfo] = []
    @Published var targetFiles: [FileInfo] = []
    @Published var isBatchMode = false
    
    // 转换历史
    @Published var conversionHistory: [ConversionRecord] = []
    
    func handleFileDrop(providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }
        
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
            if let data = item as? Data,
               let url = URL(dataRepresentation: data, relativeTo: nil) {
                DispatchQueue.main.async {
                    self.loadFile(from: url)
                }
            }
        }
    }
    
    func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        // 设置支持的文件类型
        panel.allowedContentTypes = [
            .image, .movie, .audio, .pdf, .text, .data
        ]
        
        if panel.runModal() == .OK {
            if panel.urls.count > 1 {
                // 批量模式
                loadMultipleFiles(from: panel.urls)
            } else if let url = panel.url {
                loadFile(from: url)
            }
        }
    }
    
    private func loadFile(from url: URL) {
        do {
            let fileInfo = try FileInfo(url: url)
            self.sourceFile = fileInfo
            self.targetFile = fileInfo.createTargetFile()
            self.isBatchMode = false
            self.statusMessage = "文件加载成功"
            self.statusType = .success
            
            // 清除之前的错误信息
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.statusMessage = nil
            }
        } catch {
            self.statusMessage = "无法加载文件：\(error.localizedDescription)"
            self.statusType = .error
        }
    }
    
    private func loadMultipleFiles(from urls: [URL]) {
        var loadedFiles: [FileInfo] = []
        
        for url in urls {
            do {
                let fileInfo = try FileInfo(url: url)
                loadedFiles.append(fileInfo)
            } catch {
                statusMessage = "部分文件加载失败"
                statusType = .warning
            }
        }
        
        if !loadedFiles.isEmpty {
            self.sourceFiles = loadedFiles
            self.targetFiles = loadedFiles.map { $0.createTargetFile() }
            self.isBatchMode = true
            self.statusMessage = "已加载 \(loadedFiles.count) 个文件"
            self.statusType = .success
        }
    }
    
    func addMoreFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            for url in panel.urls {
                do {
                    let fileInfo = try FileInfo(url: url)
                    sourceFiles.append(fileInfo)
                    targetFiles.append(fileInfo.createTargetFile())
                } catch {
                    statusMessage = "部分文件添加失败"
                    statusType = .warning
                }
            }
            
            statusMessage = "已添加 \(panel.urls.count) 个文件"
            statusType = .success
        }
    }
    
    func applySettingsToAll() {
        guard let template = targetFile else { return }
        
        for i in 0..<targetFiles.count {
            targetFiles[i].format = template.format
            targetFiles[i].quality = template.quality
            targetFiles[i].compressionLevel = template.compressionLevel
            targetFiles[i].customWidth = template.customWidth
            targetFiles[i].customHeight = template.customHeight
        }
        
        statusMessage = "设置已应用到所有文件"
        statusType = .success
    }
    
    func clearFiles() {
        sourceFile = nil
        targetFile = nil
        sourceFiles.removeAll()
        targetFiles.removeAll()
        isBatchMode = false
        conversionProgress = 0.0
        currentTask = ""
        statusMessage = nil
    }
    
    func startConversion() {
        if isBatchMode {
            startBatchConversion()
        } else {
            startSingleConversion()
        }
    }
    
    private func startSingleConversion() {
        guard let source = sourceFile, let target = targetFile else { return }
        
        isConverting = true
        conversionProgress = 0.0
        currentTask = "准备转换..."
        
        // 模拟转换过程
        let conversionSteps = [
            "正在读取文件...",
            "正在处理...",
            "正在压缩...",
            "正在保存...",
            "转换完成"
        ]
        
        var currentStep = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            DispatchQueue.main.async {
                if currentStep < conversionSteps.count {
                    self.currentTask = conversionSteps[currentStep]
                    self.conversionProgress = Double(currentStep + 1) / Double(conversionSteps.count)
                    currentStep += 1
                } else {
                    timer.invalidate()
                    self.isConverting = false
                    self.conversionProgress = 1.0
                    self.currentTask = ""
                    self.statusMessage = "转换完成"
                    self.statusType = .success
                    
                    // 添加到历史记录
                    let record = ConversionRecord(
                        sourceFile: source,
                        targetFile: target,
                        date: Date()
                    )
                    self.conversionHistory.append(record)
                    
                    // 执行实际转换
                    self.performConversion(from: source, to: target)
                }
            }
        }
    }
    
    private func startBatchConversion() {
        guard !sourceFiles.isEmpty else { return }
        
        isConverting = true
        conversionProgress = 0.0
        currentTask = "开始批量转换..."
        
        let totalFiles = sourceFiles.count
        var completedFiles = 0
        
        for (index, sourceFile) in sourceFiles.enumerated() {
            let targetFile = targetFiles[index]
            
            // 模拟每个文件的转换
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2) {
                self.currentTask = "正在转换 \(sourceFile.name)..."
                
                // 执行转换
                self.performConversion(from: sourceFile, to: targetFile)
                
                completedFiles += 1
                self.conversionProgress = Double(completedFiles) / Double(totalFiles)
                
                if completedFiles == totalFiles {
                    self.isConverting = false
                    self.currentTask = ""
                    self.statusMessage = "批量转换完成，共转换 \(totalFiles) 个文件"
                    self.statusType = .success
                }
            }
        }
    }
    
    private func performConversion(from source: FileInfo, to target: FileInfo) {
        // 这里实现实际的文件转换逻辑
        // 根据文件类型调用相应的转换方法
        
        if source.type.conforms(to: .image) {
            convertImage(from: source, to: target)
        } else if source.type.conforms(to: .movie) {
            convertVideo(from: source, to: target)
        } else if source.type.conforms(to: .audio) {
            convertAudio(from: source, to: target)
        } else if source.type.conforms(to: .pdf) {
            convertPDF(from: source, to: target)
        }
    }
    
    // 图片转换
    private func convertImage(from source: FileInfo, to target: FileInfo) {
        // 实现图片转换逻辑
        print("Converting image: \(source.name) -> \(target.format)")
        print("Quality: \(target.quality), Compression: \(target.compressionLevel)")
        
        // 这里可以使用 Core Graphics 或 ImageIO 框架
        // 实现实际的图片转换、压缩和格式转换
    }
    
    // 视频转换
    private func convertVideo(from source: FileInfo, to target: FileInfo) {
        // 实现视频转换逻辑
        print("Converting video: \(source.name) -> \(target.format)")
        
        // 这里可以使用 AVFoundation 框架
        // 实现视频格式转换和压缩
    }
    
    // 音频转换
    private func convertAudio(from source: FileInfo, to target: FileInfo) {
        // 实现音频转换逻辑
        print("Converting audio: \(source.name) -> \(target.format)")
        
        // 这里可以使用 AVFoundation 框架
        // 实现音频格式转换和压缩
    }
    
    // PDF转换
    private func convertPDF(from source: FileInfo, to target: FileInfo) {
        // 实现PDF转换逻辑
        print("Converting PDF: \(source.name) -> \(target.format)")
        
        // 这里可以使用 PDFKit 框架
        // 实现PDF转换为图片或其他格式
    }
}