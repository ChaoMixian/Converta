// MARK: - FileConversionManager.swift
import SwiftUI
import AVFoundation
import AppKit

class FileConversionManager: ObservableObject {
    @Published var sourceFile: ConvertaFile?
    @Published var conversionSettings = ConversionSettings()
    @Published var isConverting = false
    @Published var errorMessage: String?
    
    func setSourceFile(_ url: URL?) {
        guard let url = url else { return }
        
        do {
            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey, .typeIdentifierKey])
            let fileSize = resourceValues.fileSize ?? 0
            let typeIdentifier = resourceValues.typeIdentifier ?? ""
            
            let fileType = ConvertaFileType.from(typeIdentifier: typeIdentifier)
            
            sourceFile = ConvertaFile(
                url: url,
                name: url.lastPathComponent,
                size: fileSize,
                type: fileType
            )
            
            // 根据文件类型设置默认转换参数
            setupDefaultSettings(for: fileType)
            
        } catch {
            errorMessage = "无法读取文件信息: \(error.localizedDescription)"
        }
    }
    
    private func setupDefaultSettings(for fileType: ConvertaFileType) {
        switch fileType {
        case .image:
            conversionSettings.targetFormat = "JPEG"
            conversionSettings.imageQuality = 0.8
            conversionSettings.imageSize = "原始尺寸"
        case .video:
            conversionSettings.targetFormat = "MP4"
            conversionSettings.videoQuality = "中等"
            conversionSettings.videoResolution = "原始分辨率"
        case .audio:
            conversionSettings.targetFormat = "MP3"
            conversionSettings.audioBitrate = "192"
            conversionSettings.audioSampleRate = "44100"
        case .document:
            conversionSettings.targetFormat = "PDF"
        case .unknown:
            conversionSettings.targetFormat = "未知"
        }
    }
    
    func convertFile() {
        guard let sourceFile = sourceFile else { return }
        
        isConverting = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let outputURL = try self.performConversion(sourceFile: sourceFile)
                
                DispatchQueue.main.async {
                    self.isConverting = false
                    // 显示转换成功的结果
                    NSWorkspace.shared.selectFile(outputURL.path, inFileViewerRootedAtPath: outputURL.deletingLastPathComponent().path)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isConverting = false
                    self.errorMessage = "转换失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func performConversion(sourceFile: ConvertaFile) throws -> URL {
        let outputURL = getOutputURL(for: sourceFile)
        
        switch sourceFile.type {
        case .image:
            try convertImage(from: sourceFile.url, to: outputURL)
        case .video:
            try convertVideo(from: sourceFile.url, to: outputURL)
        case .audio:
            try convertAudio(from: sourceFile.url, to: outputURL)
        case .document:
            try convertDocument(from: sourceFile.url, to: outputURL)
        case .unknown:
            throw ConversionError.unsupportedFileType
        }
        
        return outputURL
    }
    
    private func getOutputURL(for sourceFile: ConvertaFile) -> URL {
        let desktop = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let fileName = sourceFile.url.deletingPathExtension().lastPathComponent
        let ext = getFileExtension(for: conversionSettings.targetFormat)
        return desktop.appendingPathComponent("\(fileName)_converted.\(ext)")
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
    
    private func convertImage(from sourceURL: URL, to outputURL: URL) throws {
        guard let image = NSImage(contentsOf: sourceURL) else {
            throw ConversionError.invalidImageFile
        }
        
        let targetFormat = conversionSettings.targetFormat.lowercased()
        let quality = conversionSettings.imageQuality
        
        // 创建 bitmap representation
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            throw ConversionError.imageProcessingFailed
        }
        
        // 根据格式选择输出类型
        let fileType: NSBitmapImageRep.FileType
        let properties: [NSBitmapImageRep.PropertyKey: Any]
        
        switch targetFormat {
        case "jpeg", "jpg":
            fileType = .jpeg
            properties = [.compressionFactor: quality]
        case "png":
            fileType = .png
            properties = [:]
        default:
            fileType = .jpeg
            properties = [.compressionFactor: quality]
        }
        
        guard let data = bitmapRep.representation(using: fileType, properties: properties) else {
            throw ConversionError.imageProcessingFailed
        }
        
        try data.write(to: outputURL)
    }
    
    private func convertVideo(from sourceURL: URL, to outputURL: URL) throws {
        // 简化的视频转换实现
        // 在实际应用中，这里需要使用 AVFoundation 进行更复杂的视频处理
        let asset = AVAsset(url: sourceURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            throw ConversionError.videoProcessingFailed
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        let semaphore = DispatchSemaphore(value: 0)
        var exportError: Error?
        
        exportSession.exportAsynchronously {
            exportError = exportSession.error
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if let error = exportError {
            throw error
        }
    }
    
    private func convertAudio(from sourceURL: URL, to outputURL: URL) throws {
        // 简化的音频转换实现
        throw ConversionError.notImplemented
    }
    
    private func convertDocument(from sourceURL: URL, to outputURL: URL) throws {
        // 简化的文档转换实现
        throw ConversionError.notImplemented
    }
    
    func reset() {
        sourceFile = nil
        conversionSettings = ConversionSettings()
        isConverting = false
        errorMessage = nil
    }
}