//
//  ConvertaFile.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


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