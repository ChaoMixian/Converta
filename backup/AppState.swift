//
//  AppState.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - AppState.swift
import SwiftUI
import UniformTypeIdentifiers

class AppState: ObservableObject {
    @Published var selectedItem: SidebarItem = .home
    @Published var incomingFiles: [URL] = []
    
    func handleIncomingFile(_ url: URL) {
        incomingFiles.append(url)
        // 根据文件类型自动导航到相应页面
        if let fileType = detectFileType(url) {
            selectedItem = fileType
        }
    }
    
    private func detectFileType(_ url: URL) -> SidebarItem? {
        let pathExtension = url.pathExtension.lowercased()
        
        switch pathExtension {
        case "mp4", "mov", "avi", "mkv", "wmv", "flv", "webm":
            return .videoCompress
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "webp":
            return .imageCompress
        case "mp3", "wav", "aac", "flac", "ogg", "m4a":
            return .audioConvert
        case "pdf", "doc", "docx", "txt", "rtf":
            return .documentConvert
        default:
            return nil
        }
    }
}
