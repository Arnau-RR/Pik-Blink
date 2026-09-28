//
//  MainView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase

    
    var body: some View {
        
        TabView {
            Tab("tab.bar.pik.option", systemImage: "list.bullet") {
                PikViewList()
            }
           
            Tab("tab.bar.settings.option", systemImage: "gear") {
                SettingsView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await LiveActivityManager.shared.endExpired() }
            }
        }
    }
}
    
#Preview {
    MainView()
}
