//
//  SettingsView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    //@StateObject private var viewModel = PikViewModel()
    
    var body: some View {
        
        VStack() {
            HeaderView(
                title: "Pik Blink",
                subtitle: "Capture ideas in a blink."
            ) {}
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SettingsView()
}


