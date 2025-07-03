//
//  ContentView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//
// MARK: - ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ConvertaViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text("Converta")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    viewModel.clearFiles()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(viewModel.sourceFile != nil ? 1 : 0.3)
                .disabled(viewModel.sourceFile == nil)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // 主要内容区域
            if viewModel.sourceFile != nil {
                ConversionView(viewModel: viewModel)
            } else {
                DropZoneView(viewModel: viewModel)
            }
        }
        .frame(minWidth: 800, minHeight: 500)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    ContentView()
}
