// DropZoneView.swift
import SwiftUI

struct DropZoneView: View {
    @ObservedObject var viewModel: ConvertaViewModel
    @State private var isDragOver = false
    
    var body: some View {
        VStack(spacing: 32) {
            // 拖放区域
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 48))
                    .foregroundColor(isDragOver ? .accentColor : .secondary)
                    .scaleEffect(isDragOver ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isDragOver)
                
                VStack(spacing: 8) {
                    Text("拖放文件到这里")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("支持图片、视频、音频、PDF等多种格式")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isDragOver ? Color.accentColor.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isDragOver ? Color.accentColor : Color.secondary.opacity(0.3),
                                style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                            )
                    )
            )
            .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                viewModel.handleFileDrop(providers: providers)
                return true
            }
            
            // 或者选择文件按钮
            VStack(spacing: 16) {
                Text("或者")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    viewModel.selectFile()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "folder")
                        Text("选择文件")
                    }
                    .font(.body)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}