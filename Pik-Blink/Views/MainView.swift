//
//  MainView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack() {
            HeaderView(
                title: "Pik Blink",
                subtitle: "Capture ideas in a blink."
            ) {
                GlassIconButton(icon: "magnifyingglass") {
                    viewModel.createNewItemPressed.toggle()
                }
                
                GlassIconButton(icon: "plus") {
                    viewModel.createNewItemPressed.toggle()
                }
            }
            
            ListItems(listElements: viewModel.pickList) { item in
                viewModel.toggle(item)
            } onArchive: { item in
                viewModel.archive(item)
            } onDelete: { item in
                viewModel.archive(item)
            }
        }
        .sheet(isPresented: $viewModel.createNewItemPressed) {
            CreateItemView()
                .presentationDetents([.large]) // Alturas
                .presentationDragIndicator(.visible)
        }
        
        .task {
            viewModel.configure(modelContext: context)
            try? viewModel.loadMockIfNeeded(context: context)
        }
        
    }
    
}

#Preview {
    MainView()
}
