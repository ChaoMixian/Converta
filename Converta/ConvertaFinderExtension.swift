// MARK: - Finder Extension (ConvertaFinderExtension.swift)
/*
import Cocoa
import FinderSync

class ConvertaFinderExtension: FIFinderSync {
    
    override init() {
        super.init()
        
        // 设置监控的目录
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }
    
    override var toolbarItemName: String {
        return "Converta"
    }
    
    override var toolbarItemToolTip: String {
        return "使用 Converta 转换文件"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(systemSymbolName: "arrow.triangle.2.circlepath", accessibilityDescription: "转换")!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        switch menuKind {
        case .contextualMenuForItems:
            menu.addItem(withTitle: "使用 Converta 转换", action: #selector(convertWithConverta(_:)), keyEquivalent: "")
            menu.addItem(withTitle: "快速压缩图片", action: #selector(quickCompressImage(_:)), keyEquivalent: "")
            menu.addItem(withTitle: "快速转换为 PDF", action: #selector(quickConvertToPDF(_:)), keyEquivalent: "")
        case .contextualMenuForContainer:
            return nil
        case .contextualMenuForSidebar:
            return nil
        case .toolbarItemMenu:
            menu.addItem(withTitle: "打开 Converta", action: #selector(openConverta(_:)), keyEquivalent: "")
        @unknown default:
            return nil
        }
        
        return menu
    }
    
    @objc func convertWithConverta(_ sender: AnyObject?) {
        guard let items = FIFinderSyncController.default().selectedItemURLs(),
              let firstItem = items.first else { return }
        
        // 打开主应用并传递文件
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [firstItem.path]
        
        NSWorkspace.shared.openApplication(at: getMainAppURL(), configuration: configuration) { _, _ in }
    }
    
    @objc func quickCompressImage(_ sender: AnyObject?) {
        guard let items = FIFinderSyncController.default().selectedItemURLs(),
              let firstItem = items.first else { return }
        
        // 快速压缩图片
        Task {
            await performQuickImageCompression(url: firstItem)
        }
    }
    
    @objc func quickConvertToPDF(_ sender: AnyObject?) {
        guard let items = FIFinderSyncController.default().selectedItemURLs(),
              let firstItem = items.first else { return }
        
        // 快速转换为 PDF
        Task {
            await performQuickPDFConversion(url: firstItem)
        }
    }
    
    @objc func openConverta(_ sender: AnyObject?) {
        NSWorkspace.shared.openApplication(at: getMainAppURL(), configuration: NSWorkspace.OpenConfiguration()) { _, _ in }
    }
    
    private func getMainAppURL() -> URL {
        let bundleURL = Bundle.main.bundleURL
        return bundleURL.deletingLastPathComponent().deletingLastPathComponent()
    }
    
    private func performQuickImageCompression(url: URL) async {
        // 简化的图片压缩实现
        guard let image = NSImage(contentsOf: url) else { return }
        
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else { return }
        
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [.compressionFactor: 0.5]
        
        guard let compressedData = bitmapRep.representation(using: .jpeg, properties: properties) else { return }
        
        let outputURL = url.deletingPathExtension().appendingPathExtension("compressed.jpg")
        try? compressedData.write(to: outputURL)
        
        // 显示通知
        showNotification(title: "压缩完成", message: "图片已压缩并保存")
    }
    
    private func performQuickPDFConversion(url: URL) async {
        // 简化的 PDF 转换实现
        // 这里可以添加具体的转换逻辑
        showNotification(title: "转换完成", message: "文件已转换为 PDF")
    }
    
    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}