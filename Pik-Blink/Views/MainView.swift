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
            .padding(.horizontal, 20)
            
            Picker("", selection: $viewModel.selectedTab) {
                Text(String(localized: "main.view.picker.pending")).tag(0)
                Text(String(localized: "main.view.picker.completed")).tag(1)
                Text(String(localized: "main.view.picker.archived")).tag(2)
            }
            .pickerStyle(.segmented)
            .padding()

            List {
                ListItems(listElements: viewModel.filteredPiks) { item in
                    viewModel.toggle(item)
                } onArchive: { item in
                    viewModel.archive(item)
                } onDelete: { item in
                    viewModel.delete(item)
                }
            }
            .layoutPriority(1)
        }

        .sheet(
            isPresented: $viewModel.createNewItemPressed,
            onDismiss: {
                viewModel.reload()
            }
        ) {
            CreateItemView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        
        .task {
            viewModel.configure(modelContext: context)
            await viewModel.loadPiksStored()
        }
        
    }
    
}

#Preview {
    MainView()
}
