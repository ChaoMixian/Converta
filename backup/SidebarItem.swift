//
//  SidebarItem.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - SidebarItem.swift
import Foundation

enum SidebarItem: String, CaseIterable, Identifiable {
    case home = "home"
    case videoCompress = "video_compress"
    case videoConvert = "video_convert"
    case imageCompress = "image_compress"
    case imageConvert = "image_convert"
    case audioConvert = "audio_convert"
    case documentConvert = "document_convert"
    case batchProcess = "batch_process"
    case finderExtension = "finder_extension"
    case settings = "settings"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "首页"
        case .videoCompress: return "视频压缩"
        case .videoConvert: return "视频转换"
        case .imageCompress: return "图片压缩"
        case .imageConvert: return "图片转换"
        case .audioConvert: return "音频转换"
        case .documentConvert: return "文档转换"
        case .batchProcess: return "批量处理"
        case .finderExtension: return "Finder 扩展"
        case .settings: return "设置"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .videoCompress: return "video.compress"
        case .videoConvert: return "video.badge.checkmark"
        case .imageCompress: return "photo.compress"
        case .imageConvert: return "photo.badge.arrow.down"
        case .audioConvert: return "music.note.list"
        case .documentConvert: return "doc.badge.arrow.up"
        case .batchProcess: return "square.stack.3d.down.right"
        case .finderExtension: return "folder.badge.gearshape"
        case .settings: return "gear"
        }
    }
    
    var category: String {
        switch self {
        case .home:
            return "快速访问"
        case .videoCompress, .videoConvert:
            return "视频处理"
        case .imageCompress, .imageConvert:
            return "图片处理"
        case .audioConvert:
            return "音频处理"
        case .documentConvert:
            return "文档处理"
        case .batchProcess:
            return "批量工具"
        case .finderExtension:
            return "系统集成"
        case .settings:
            return "应用设置"
        }
    }
}