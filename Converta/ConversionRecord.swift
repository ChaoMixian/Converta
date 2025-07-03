// ConversionRecord.swift
import Foundation

struct ConversionRecord: Identifiable {
    let id = UUID()
    let sourceFile: FileInfo
    let targetFile: FileInfo
    let date: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}