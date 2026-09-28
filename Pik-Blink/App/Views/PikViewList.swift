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
    @FocusState private var searchFocused: Bool

    var body: some View {

        VStack {
            HeaderView(
                title: "main.view.header.title",
                subtitle: "main.view.header.subtitle"
            ) {
                GlassIconButton(icon: "magnifyingglass") {
                    viewModel.toggleSearch()
                }

                GlassIconButton(icon: "plus") {
                    viewModel.createNewItemPressed.toggle()
                }
            }
            .padding(.horizontal, 20)

            if viewModel.isSearching {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("main.view.search.prompt", text: $viewModel.searchText)
                        .focused($searchFocused)
                        .submitLabel(.search)

                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(.thinMaterial, in: Capsule())
                .padding(.horizontal, 20)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Picker("", selection: $viewModel.selectedTab) {
                Text("main.view.picker.pending").tag(0)
                Text("main.view.picker.completed").tag(1)
                Text("main.view.picker.archived").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()

            List {
                ListItems(
                    listElements: viewModel.filteredPiks(from: piks),
                    showArchivedActions: viewModel.selectedTab == 2,
                    forceExpanded: !viewModel.searchText.isEmpty,
                    onPress: { item in viewModel.onPressed(item) },
                    onToggle: { item in viewModel.toggle(item) },
                    onArchive: { item in viewModel.archive(item) },
                    onUnarchive: { item in viewModel.unarchive(item) },
                    onDelete: { item in viewModel.delete(item) }
                )
            }
            .layoutPriority(1)
        }
        .animation(.default, value: viewModel.isSearching)
        .onChange(of: viewModel.isSearching) { _, isSearching in
            searchFocused = isSearching
        }

        .sheet(isPresented: $viewModel.createNewItemPressed) {
            NavigationStack {
                CreateItemView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }

        .sheet(isPresented: $viewModel.editExistingItemPressed) {
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
