//
//  FinderExtensionView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - Views/FinderExtensionView.swift
import SwiftUI

struct FinderExtensionView: View {
    @State private var isExtensionEnabled = false
    @State private var showingInstallInstructions = false
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题区域
            VStack(spacing: 16) {
                Image(systemName: "folder.badge.gearshape")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                
                Text("Finder 扩展")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("在 Finder 工具栏中直接使用 Converta 处理文件")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // 状态卡片
            GroupBox {
                HStack(spacing: 16) {
                    Image(systemName: isExtensionEnabled ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isExtensionEnabled ? .green : .orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isExtensionEnabled ? "扩展已启用" : "扩展未启用")
                            .font(.headline)
                        
                        Text(isExtensionEnabled ? "你可以在 Finder 工具栏中使用 Converta 按钮" : "请按照下方说明启用扩展")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // 功能说明
            VStack(alignment: .leading, spacing: 16) {
                Text("扩展功能")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(
                        icon: "hand.point.up.braille",
                        title: "工具栏按钮",
                        description: "在 Finder 工具栏中添加 Converta 按钮"
                    )
                    
                    FeatureRow(
                        icon: "cursor.rays",
                        title: "快速处理",
                        description: "选择文件后点击按钮即可快速处理"
                    )
                    
                    FeatureRow(
                        icon: "arrow.triangle.2.circlepath",
                        title: "自动识别",
                        description: "自动识别文件类型并跳转到相应功能"
                    )
                    
                    FeatureRow(
                        icon: "square.stack.3d.down.right",
                        title: "批量处理",
                        description: "支持同时选择多个文件进行批量处理"
                    )
                }
            }
            
            // 操作按钮
            VStack(spacing: 12) {
                Button(action: {
                    if isExtensionEnabled {
                        disableExtension()
                    } else {
                        showingInstallInstructions = true
                    }
                }) {
                    Text(isExtensionEnabled ? "禁用扩展" : "启用扩展")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("检查扩展状态") {
                    checkExtensionStatus()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            checkExtensionStatus()
        }
        .alert("启用 Finder 扩展", isPresented: $showingInstallInstructions) {
            Button("打开系统偏好设置") {
                openSystemPreferences()
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("1. 点击下方按钮打开系统偏好设置\n2. 选择「扩展」\n3. 在「Finder 扩展」中启用 Converta\n4. 重新启动 Finder")
        }
    }
    
    private func checkExtensionStatus() {
        // 检查扩展是否已启用
        // 这里需要调用 Finder Extension 的 API
        isExtensionEnabled = false // 临时设置
    }
    
    private func disableExtension() {
        // 禁用扩展的逻辑
        isExtensionEnabled = false
    }
    
    private func openSystemPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.extensions")!
        NSWorkspace.shared.open(url)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
