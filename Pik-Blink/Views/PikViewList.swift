//
//  PikViewList.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import SwiftData

struct PikViewList: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = PikViewModel()
    
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
                Text(localized( "main.view.picker.pending" )).tag(0)
                Text(localized( "main.view.picker.completed")).tag(1)
                Text(localized( "main.view.picker.archived")).tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            List {
                ListItems(
                    listElements: viewModel.filteredPiks,
                    showArchivedActions: viewModel.selectedTab == 2
                ) { item in
                    viewModel.toggle(item)
                } onArchive: { item in
                    viewModel.archive(item)
                } onUnarchive: { item in
                    viewModel.unarchive(item)
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
            NavigationStack {
                CreateItemView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        
        .task {
            NotificationManager.shared.registerCategories()

            viewModel.configure(modelContext: context)
            await viewModel.loadPiksStored()
            viewModel.checkNotificationAuthorization()
        }
        .onReceive(NotificationCenter.default.publisher(for: .pikCompleted)) { _ in
            viewModel.reload()
        }
        
    }
    
}

#Preview {
    PikViewList()
}
