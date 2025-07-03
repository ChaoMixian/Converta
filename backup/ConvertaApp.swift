//
//  ConvertaApp.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//

import SwiftUI

@main
struct ConvertaApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.automatic)
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
//        .onOpenURL { url in
//            appState.handleIncomingFile(url)
//        }
    }
}
