//
//  DetailView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - DetailView.swift
import SwiftUI

struct DetailView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            switch appState.selectedItem {
            case .home:
                HomeView()
            case .videoConvert:
                VideoConvertView()
            case .imageConvert:
                ImageConvertView()
            case .audioConvert:
                AudioConvertView()
            case .documentConvert:
                DocumentConvertView()
            case .batchProcess:
                BatchProcessView()
            case .finderExtension:
                FinderExtensionView()
            case .settings:
                SettingsView()
            }
        }
        .navigationTitle(appState.selectedItem.title)
        .navigationSubtitle(appState.selectedItem.category)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "sidebar.left")
                }
                .help("切换侧边栏")
            }
        }
    }
}
