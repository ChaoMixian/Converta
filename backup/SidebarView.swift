//
//  SidebarView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - SidebarView.swift
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    
    private let categories = Dictionary(grouping: SidebarItem.allCases, by: \.category)
    private let categoryOrder = ["快速访问", "视频处理", "图片处理", "音频处理", "文档处理", "批量工具", "系统集成", "应用设置"]
    
    var body: some View {
        List(selection: $appState.selectedItem) {
            ForEach(categoryOrder, id: \.self) { category in
                if let items = categories[category] {
                    Section(category) {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                Label {
                                    Text(item.title)
                                        .font(.system(size: 13))
                                } icon: {
                                    Image(systemName: item.icon)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .tag(item)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Converta")
    }
}
