// MARK: - Models.swift
import Foundation

struct ConvertaFile {
    let url: URL
    let name: String
    let size: Int
    let type: ConvertaFileType
}

enum ConvertaFileType: String, CaseIterable {
    case image = "图片"
    case video = "视频"
    case audio = "音频"
    case document = "文档"
    case unknown = "未知"
    
    static func from(typeIdentifier: String) -> ConvertaFileType {
        if typeIdentifier.hasPrefix("public.image") {
            return .image
        } else if typeIdentifier.hasPrefix("public.movie") || typeIdentifier.hasPrefix("public.video") {
            return .video
        } else if typeIdentifier.hasPrefix("public.audio") {
            return .audio
        } else if typeIdentifier.hasPrefix("public.text") || typeIdentifier.hasPrefix("com.adobe.pdf") {
            return .document
        } else {
            return .unknown
        }
    }
    
    var icon: String {
        switch self {
        case .image: return "photo"
        case .video: return "video"
        case .audio: return "music.note"
        case .document: return "doc"
        case .unknown: return "questionmark"
        }
    }
}

struct ConversionSettings {
    var targetFormat: String = ""
    
    // 图片设置
    var imageQuality: Double = 0.8
    var imageSize: String = "原始尺寸"
    
    // 视频设置
    var videoQuality: String = "中等"
    var videoResolution: String = "原始分辨率"
    
    // 音频设置
    var audioBitrate: String = "192"
    var audioSampleRate: String = "44100"
}

enum ConversionError: Error, LocalizedError {
    case unsupportedFileType
    case invalidImageFile
    case imageProcessingFailed
    case videoProcessingFailed
    case audioProcessingFailed
    case documentProcessingFailed
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .unsupportedFileType:
            return "不支持的文件类型"
        case .invalidImageFile:
            return "无效的图片文件"
        case .imageProcessingFailed:
            return "图片处理失败"
        case .videoProcessingFailed:
            return "视频处理失败"
        case .audioProcessingFailed:
            return "音频处理失败"
        case .documentProcessingFailed:
            return "文档处理失败"
        case .notImplemented:
            return "功能尚未实现"
        }
    }
}
