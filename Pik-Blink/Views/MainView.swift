//
//  MainView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
//    @Environment(\.modelContext) private var context
//    //@StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        
        TabView {
            Tab("Pik", systemImage: "house") {
                // 2.
                PikViewList()
            }
           
            Tab("Search", systemImage: "magnifyingglass") {
                SettingsView()
            }
        }
        // 3.
        .tabBarMinimizeBehavior(.onScrollDown)
        
    }
}
    
#Preview {
    MainView()
}
