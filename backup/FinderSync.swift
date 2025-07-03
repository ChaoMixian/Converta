//
//  FinderSync.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - FinderSync.swift (Finder Extension Target)
import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    override init() {
        super.init()
        // 监控用户的主目录
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: NSHomeDirectory())]
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // 当 Finder 开始监控目录时调用
        NSLog("Converta Finder Extension: Begin observing directory at \(url)")
    }
    
    override func endObservingDirectory(at url: URL) {
        // 当 Finder 结束监控目录时调用
        NSLog("Converta Finder Extension: End observing directory at \(url)")
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "Converta"
    }
    
    override var toolbarItemToolTip: String {
        return "转换选中的文件"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: "ToolbarIcon") ?? NSImage(named: NSImage.actionTemplateName)!
    }
    
    // MARK: - Context Menu Support
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        switch menuKind {
        case .contextualMenuForItems:
            return createContextualMenu()
        case .contextualMenuForContainer:
            return nil
        case .contextualMenuForSidebar:
            return nil
        case .toolbarItemMenu:
            return createToolbarMenu()
        @unknown default:
            return nil
        }
    }
    
    private func createContextualMenu() -> NSMenu {
        let menu = NSMenu(title: "")
        
        // 添加转换菜单项
        let convertMenuItem = NSMenuItem(title: "转换文件", action: #selector(convertSelectedFiles(_:)), keyEquivalent: "")
        convertMenuItem.target = self
        menu.addItem(convertMenuItem)
        
        // 添加分隔符
        menu.addItem(NSMenuItem.separator())
        
        // 添加具体的转换选项
        let imageMenuItem = NSMenuItem(title: "图像转换", action: nil, keyEquivalent: "")
        let imageSubmenu = NSMenu(title: "图像转换")
        
        // 图像转换子菜单
        let toJPEG = NSMenuItem(title: "转换为 JPEG", action: #selector(convertToJPEG(_:)), keyEquivalent: "")
        let toPNG = NSMenuItem(title: "转换为 PNG", action: #selector(convertToPNG(_:)), keyEquivalent: "")
        let toWebP = NSMenuItem(title: "转换为 WebP", action: #selector(convertToWebP(_:)), keyEquivalent: "")
        let toHEIC = NSMenuItem(title: "转换为 HEIC", action: #selector(convertToHEIC(_:)), keyEquivalent: "")
        
        [toJPEG, toPNG, toWebP, toHEIC].forEach { item in
            item.target = self
            imageSubmenu.addItem(item)
        }
        
        imageMenuItem.submenu = imageSubmenu
        menu.addItem(imageMenuItem)
        
        // 视频转换菜单
        let videoMenuItem = NSMenuItem(title: "视频转换", action: nil, keyEquivalent: "")
        let videoSubmenu = NSMenu(title: "视频转换")
        
        let toMP4 = NSMenuItem(title: "转换为 MP4", action: #selector(convertToMP4(_:)), keyEquivalent: "")
        let toMOV = NSMenuItem(title: "转换为 MOV", action: #selector(convertToMOV(_:)), keyEquivalent: "")
        let toAVI = NSMenuItem(title: "转换为 AVI", action: #selector(convertToAVI(_:)), keyEquivalent: "")
        
        [toMP4, toMOV, toAVI].forEach { item in
            item.target = self
            videoSubmenu.addItem(item)
        }
        
        videoMenuItem.submenu = videoSubmenu
        menu.addItem(videoMenuItem)
        
        // 音频转换菜单
        let audioMenuItem = NSMenuItem(title: "音频转换", action: nil, keyEquivalent: "")
        let audioSubmenu = NSMenu(title: "音频转换")
        
        let toMP3 = NSMenuItem(title: "转换为 MP3", action: #selector(convertToMP3(_:)), keyEquivalent: "")
        let toAAC = NSMenuItem(title: "转换为 AAC", action: #selector(convertToAAC(_:)), keyEquivalent: "")
        let toFLAC = NSMenuItem(title: "转换为 FLAC", action: #selector(convertToFLAC(_:)), keyEquivalent: "")
        
        [toMP3, toAAC, toFLAC].forEach { item in
            item.target = self
            audioSubmenu.addItem(item)
        }
        
        audioMenuItem.submenu = audioSubmenu
        menu.addItem(audioMenuItem)
        
        return menu
    }
    
    private func createToolbarMenu() -> NSMenu {
        let menu = NSMenu(title: "")
        
        let convertItem = NSMenuItem(title: "转换选中文件", action: #selector(convertSelectedFiles(_:)), keyEquivalent: "")
        convertItem.target = self
        menu.addItem(convertItem)
        
        return menu
    }
    
    // MARK: - Action Methods
    
    @objc private func convertSelectedFiles(_ sender: AnyObject?) {
        let selectedURLs = FIFinderSyncController.default().selectedItemURLs() ?? []
        
        if selectedURLs.isEmpty {
            showAlert(title: "提示", message: "请选择要转换的文件")
            return
        }
        
        // 显示转换选项对话框
        showConversionOptionsDialog(for: selectedURLs)
    }
    
    // MARK: - Specific Conversion Methods
    
    @objc private func convertToJPEG(_ sender: AnyObject?) {
        convertSelectedFiles(to: "jpeg")
    }
    
    @objc private func convertToPNG(_ sender: AnyObject?) {
        convertSelectedFiles(to: "png")
    }
    
    @objc private func convertToWebP(_ sender: AnyObject?) {
        convertSelectedFiles(to: "webp")
    }
    
    @objc private func convertToHEIC(_ sender: AnyObject?) {
        convertSelectedFiles(to: "heic")
    }
    
    @objc private func convertToMP4(_ sender: AnyObject?) {
        convertSelectedFiles(to: "mp4")
    }
    
    @objc private func convertToMOV(_ sender: AnyObject?) {
        convertSelectedFiles(to: "mov")
    }
    
    @objc private func convertToAVI(_ sender: AnyObject?) {
        convertSelectedFiles(to: "avi")
    }
    
    @objc private func convertToMP3(_ sender: AnyObject?) {
        convertSelectedFiles(to: "mp3")
    }
    
    @objc private func convertToAAC(_ sender: AnyObject?) {
        convertSelectedFiles(to: "aac")
    }
    
    @objc private func convertToFLAC(_ sender: AnyObject?) {
        convertSelectedFiles(to: "flac")
    }
    
    // MARK: - Helper Methods
    
    private func convertSelectedFiles(to format: String) {
        let selectedURLs = FIFinderSyncController.default().selectedItemURLs() ?? []
        
        if selectedURLs.isEmpty {
            showAlert(title: "提示", message: "请选择要转换的文件")
            return
        }
        
        // 调用主应用程序进行转换
        performConversion(urls: selectedURLs, format: format)
    }
    
    private func performConversion(urls: [URL], format: String) {
        // 创建 URL Scheme 调用主应用
        var urlComponents = URLComponents()
        urlComponents.scheme = "converta"
        urlComponents.host = "convert"
        urlComponents.path = "/\(format)"
        
        // 将文件路径编码为查询参数
        let filePaths = urls.map { $0.path }
        let encodedPaths = filePaths.joined(separator: "|")
        urlComponents.queryItems = [URLQueryItem(name: "files", value: encodedPaths)]
        
        guard let url = urlComponents.url else {
            showAlert(title: "错误", message: "无法创建转换请求")
            return
        }
        
        // 打开主应用程序
        NSWorkspace.shared.open(url)
    }
    
    private func showConversionOptionsDialog(for urls: [URL]) {
        // 这里可以显示一个更复杂的对话框让用户选择转换选项
        // 为了简化，我们直接调用主应用
        var urlComponents = URLComponents()
        urlComponents.scheme = "converta"
        urlComponents.host = "convert"
        urlComponents.path = "/options"
        
        let filePaths = urls.map { $0.path }
        let encodedPaths = filePaths.joined(separator: "|")
        urlComponents.queryItems = [URLQueryItem(name: "files", value: encodedPaths)]
        
        guard let url = urlComponents.url else {
            showAlert(title: "错误", message: "无法创建转换请求")
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButton(withTitle: "确定")
            alert.runModal()
        }
    }
    
    // MARK: - Validation
    
//    override func requestBadgeIdentifier(for url: URL) {
//        // 可以在这里为正在转换的文件添加徽章
//        // 例如显示转换进度或状态
//    }
//    
//    override func values(forBadgeIdentifier badgeIdentifier: String) -> (NSImage?, String?) {
//        // 返回徽章图像和标签
//        switch badgeIdentifier {
//        case "converting":
//            return (NSImage(named: "ConvertingBadge"), "转换中")
//        case "completed":
//            return (NSImage(named: "CompletedBadge"), "已完成")
//        default:
//            return (nil, nil)
//        }
//    }
}
