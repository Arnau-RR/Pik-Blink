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
            Tab("Pik", systemImage: "list.bullet") {
                PikViewList()
            }
           
            Tab("Search", systemImage: "gear") {
                SettingsView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
    
#Preview {
    MainView()
}
