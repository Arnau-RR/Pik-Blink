//
//  MainView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
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
    }
}
    
#Preview {
    MainView()
}
