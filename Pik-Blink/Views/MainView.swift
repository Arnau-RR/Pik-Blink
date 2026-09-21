//
//  MainView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button {
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            .padding()
        }
        
    }
}

#Preview {
    MainView()
}
