// MARK: - Components/UniversalDropZone.swift
import SwiftUI
import UniformTypeIdentifiers

struct UniversalDropZone: View {
    let onFilesDropped: ([URL]) -> Void
    
    @State private var isDragOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.down.on.square.fill")
                .font(.system(size: 48))
                .foregroundColor(isDragOver ? .accentColor : .secondary)
            
            VStack(spacing: 8) {
                Text("拖拽任意文件到此处")
                    .font(.headline)
                    .foregroundColor(isDragOver ? .accentColor : .primary)
                
                Text("支持视频、图片、音频、文档等多种格式")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("文件会自动进入相应的处理模块")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isDragOver ? Color.accentColor : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [12, 6])
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isDragOver ? Color.accentColor.opacity(0.1) : Color.clear)
                )
        )
        .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    urls.append(url)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !urls.isEmpty {
                onFilesDropped(urls)
            }
        }
        
        return true
    }
}