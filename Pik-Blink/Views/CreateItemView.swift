//
//  CreateItemView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI

struct CreateItemView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = CreateItemViewModel()
    
    var body: some View {
        
        VStack {
            
            HStack {
                GlassIconButton(icon: "x.circle.fill") {
                    dismiss()
                }
                Spacer()
                GlassIconButton(icon: "square.and.arrow.down") {
                    dismiss()
                }

            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            
            HeaderView(title: String(localized: "new.item.title")) {}

//            Picker("", selection: $viewModel.selectedTab) {
//                Text("Texto").tag(0)
//                Text("Audio").tag(1)
//            }
//            .pickerStyle(.segmented)
//
//            Spacer()
//
//            if viewModel.selectedTab == 0 {
                PikTextField(text: $viewModel.pikItem)
                    .frame(height: 100)
//            } else {
//                Text("Pantalla de Audio")
//            }

            Spacer()
            
            
        }
        .padding()
        
    }
    
}
