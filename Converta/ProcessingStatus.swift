// MARK: - Models/ProcessingStatus.swift
import Foundation

enum ProcessingStatus: Equatable {
    case idle
    case processing
    case completed
    case error(String)
}
