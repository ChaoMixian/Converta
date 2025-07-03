//
//  ProcessingStatus.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - Models/ProcessingStatus.swift
import Foundation

enum ProcessingStatus: Equatable {
    case idle
    case processing
    case completed
    case error(String)
}
