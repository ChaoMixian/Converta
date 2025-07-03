// MARK: - BatchConversionManager.swift
class BatchConversionManager: ObservableObject {
    @Published var batchFiles: [ConvertaFile] = []
    @Published var isProcessing = false
    @Published var progress: Double = 0
    @Published var currentProcessingFile: String = ""
    
    func addFiles(_ urls: [URL]) {
        for url in urls {
            do {
                let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey, .typeIdentifierKey])
                let fileSize = resourceValues.fileSize ?? 0
                let typeIdentifier = resourceValues.typeIdentifier ?? ""
                let fileType = ConvertaFileType.from(typeIdentifier: typeIdentifier)
                
                let file = ConvertaFile(
                    url: url,
                    name: url.lastPathComponent,
                    size: fileSize,
                    type: fileType
                )
                
                batchFiles.append(file)
            } catch {
                print("Error reading file: \(error)")
            }
        }
    }
    
    func removeFile(at index: Int) {
        batchFiles.remove(at: index)
    }
    
    func processFiles(with settings: ConversionSettings) {
        isProcessing = true
        progress = 0
        
        Task {
            for (index, file) in batchFiles.enumerated() {
                await MainActor.run {
                    currentProcessingFile = file.name
                }
                
                // 执行转换
                await processFile(file, with: settings)
                
                await MainActor.run {
                    progress = Double(index + 1) / Double(batchFiles.count)
                }
            }
            
            await MainActor.run {
                isProcessing = false
                currentProcessingFile = ""
                batchFiles.removeAll()
            }
        }
    }
    
    private func processFile(_ file: ConvertaFile, with settings: ConversionSettings) async {
        // 简化的批处理逻辑
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 模拟处理时间
    }
}
