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
            ListItems(listElements: viewModel.pickList) { item in
                viewModel.toggle(item)
            } onArchive: { item in
                viewModel.archive(item)
            } onDelete: { item in
                viewModel.archive(item)
            }

//            Button {
//                } label: {
//                    Image(systemName: "plus")
//                        .font(.title.weight(.semibold))
//                        .padding()
//                        .background(Color.purple)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                }
//            .padding()
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
