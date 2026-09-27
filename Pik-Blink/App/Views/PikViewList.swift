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

    @Query(sort: \PikItem.createdAt, order: .reverse)
    private var piks: [PikItem]

    @StateObject private var viewModel = PikViewModel()

    var body: some View {

        VStack() {
            HeaderView(
                title: "main.view.header.title",
                subtitle: "main.view.header.subtitle"
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
                ListItems(
                    listElements: viewModel.filteredPiks(from: piks),
                    showArchivedActions: viewModel.selectedTab == 2
                ) { item in
                    viewModel.onPressed(item)
                } onToggle: { item in
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
            isPresented: $viewModel.createNewItemPressed) {
            NavigationStack {
                CreateItemView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }

        .sheet(
            isPresented: $viewModel.editExistingItemPressed ) {
            NavigationStack {
                CreateItemView(itemToEdit: viewModel.selectedPik)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }

        .task {
            NotificationManager.shared.registerCategories()

            viewModel.configure(modelContext: context)
            viewModel.checkNotificationAuthorization()
        }
        .onOpenURL { url in
            guard url.scheme == "pikblink",
                  url.host == "new" else { return }

            viewModel.createNewItemPressed = true
        }

    }

}

#Preview {
    PikViewList()
}
