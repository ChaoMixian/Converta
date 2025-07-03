// MARK: - HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    private let quickAccessItems: [SidebarItem] = [
        .videoCompress, .videoConvert, .imageCompress, .imageConvert,
        .audioConvert, .documentConvert, .batchProcess, .finderExtension
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 欢迎区域
                VStack(spacing: 16) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    
                    Text("欢迎使用 Converta")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("强大的文件转换和处理工具")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // 文件拖拽区域
                UniversalDropZone { files in
                    handleDroppedFiles(files)
                }
                .frame(height: 200)
                
                // 快速访问
                VStack(alignment: .leading, spacing: 20) {
                    Text("快速访问")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 16)
                    ], spacing: 16) {
                        ForEach(quickAccessItems, id: \.self) { item in
                            QuickAccessCard(item: item) {
                                appState.selectedItem = item
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .padding()
    }
    
    private func handleDroppedFiles(_ files: [URL]) {
        for file in files {
            appState.handleIncomingFile(file)
        }
    }
}