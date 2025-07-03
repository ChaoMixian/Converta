// FileInfo.swift - 增强版本
import SwiftUI
import UniformTypeIdentifiers

struct FileInfo: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
    let size: Int64
    let type: UTType
    var format: String
    var compressionLevel: Double = 0.8
    var quality: Double = 0.9
    var customWidth: Int?
    var customHeight: Int?
    
    init(url: URL) throws {
        self.url = url
        self.name = url.lastPathComponent
        
        let resources = try url.resourceValues(forKeys: [.fileSizeKey])
        self.size = Int64(resources.fileSize ?? 0)
        
        if let typeIdentifier = try url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
           let utType = UTType(typeIdentifier) {
            self.type = utType
        } else {
            self.type = UTType.data
        }
        
        self.format = url.pathExtension.lowercased()
    }
    
    func createTargetFile() -> FileInfo {
        var target = self
        target.format = getDefaultTargetFormat()
        return target
    }
    
    private func getDefaultTargetFormat() -> String {
        if type.conforms(to: .image) {
            return "jpg"
        } else if type.conforms(to: .movie) {
            return "mp4"
        } else if type.conforms(to: .audio) {
            return "mp3"
        } else if type.conforms(to: .pdf) {
            return "pdf"
        }
        return format
    }
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var icon: String {
        if type.conforms(to: .image) {
            return "photo"
        } else if type.conforms(to: .movie) {
            return "film"
        } else if type.conforms(to: .audio) {
            return "music.note"
        } else if type.conforms(to: .pdf) {
            return "doc.text"
        }
        return "doc"
    }
    
    var dimensions: String? {
        if type.conforms(to: .image) {
            // 这里可以获取图片的实际尺寸
            // 返回类似 "1920×1080" 的格式
            return "1920×1080" // 示例数据
        }
        return nil
    }
    
    var supportsQuality: Bool {
        return type.conforms(to: .image) || type.conforms(to: .movie)
    }
    
    var availableFormats: [String] {
        if type.conforms(to: .image) {
            return ["jpg", "png", "webp", "tiff", "bmp", "heic"]
        } else if type.conforms(to: .movie) {
            return ["mp4", "mov", "avi", "mkv", "webm", "m4v"]
        } else if type.conforms(to: .audio) {
            return ["mp3", "aac", "wav", "flac", "ogg", "m4a"]
        } else if type.conforms(to: .pdf) {
            return ["pdf", "jpg", "png", "tiff"]
        }
        return [format]
    }
    
    var estimatedOutputSize: String {
        let compressionFactor = 1.0 - compressionLevel
        let qualityFactor = quality
        let estimatedSize = Double(size) * compressionFactor * qualityFactor
        
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(estimatedSize))
    }
}