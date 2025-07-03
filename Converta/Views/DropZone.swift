//
//  DropZone.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - DropZone.swift
import SwiftUI
import UniformTypeIdentifiers

struct DropZone: View {
    @Binding var isDragging: Bool
    let onFilesDropped: ([URL]) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("拖放文件到这里")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("或者")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button("选择文件") {
                selectFile()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDragging ? Color.blue.opacity(0.1) : Color.clear)
                .strokeBorder(
                    isDragging ? Color.blue : Color.gray.opacity(0.5),
                    style: StrokeStyle(lineWidth: 2, dash: [5])
                )
        )
        .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                onFilesDropped([url])
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        let dispatchGroup = DispatchGroup()
        var urls: [URL] = []
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                dispatchGroup.enter()
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (data, error) in
                    if let data = data as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil) {
                        urls.append(url)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !urls.isEmpty {
                onFilesDropped(urls)
            }
        }
        
        return true
    }
}
