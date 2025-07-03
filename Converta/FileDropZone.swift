// MARK: - Components/FileDropZone.swift
import SwiftUI
import UniformTypeIdentifiers

struct FileDropZone: View {
    let title: String
    let acceptedTypes: [UTType]
    let onFilesDropped: ([URL]) -> Void
    
    @State private var isDragOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 48))
                .foregroundColor(isDragOver ? .accentColor : .secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isDragOver ? .accentColor : .primary)
                
                Text("拖拽文件到此处或点击选择")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button("选择文件") {
                selectFiles()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isDragOver ? Color.accentColor : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [8])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isDragOver ? Color.accentColor.opacity(0.1) : Color.clear)
                )
        )
        .onDrop(of: acceptedTypes, isTargeted: $isDragOver) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func selectFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = acceptedTypes
        
        if panel.runModal() == .OK {
            onFilesDropped(panel.urls)
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
