//
//  ConversionView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// ConversionView.swift
import SwiftUI

struct ConversionView: View {
    @ObservedObject var viewModel: ConvertaViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // 转换界面
            HStack(spacing: 24) {
                // 源文件卡片
                FileCard(
                    file: viewModel.sourceFile!,
                    isEditable: false,
                    title: "源文件"
                )
                .frame(maxWidth: .infinity)
                
                // 箭头指示器
                ConversionArrow(isConverting: viewModel.isConverting)
                    .frame(width: 80)
                
                // 目标文件卡片
                FileCard(
                    file: viewModel.targetFile!,
                    isEditable: true,
                    title: "转换为"
                )
                .frame(maxWidth: .infinity)
            }
            
            // 转换进度
            if viewModel.isConverting {
                ProgressView(value: viewModel.conversionProgress) {
                    Text("转换中...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: 300)
            }
            
//            // 错误信息
//            if let error = viewModel.conversionError {
//                Text(error)
//                    .font(.caption)
//                    .foregroundColor(.red)
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
//                    .background(Color.red.opacity(0.1))
//                    .cornerRadius(6)
//            }
            
            // 转换按钮
            Button(action: {
                viewModel.startConversion()
            }) {
                HStack(spacing: 8) {
                    if viewModel.isConverting {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    Text(viewModel.isConverting ? "转换中..." : "开始转换")
                }
                .font(.body)
                .fontWeight(.medium)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(viewModel.isConverting ? Color.gray : Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.isConverting)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
