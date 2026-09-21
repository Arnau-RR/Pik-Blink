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

            PikTextField(
                text: $viewModel.pikItem,
                isRecording: viewModel.isRecording
            ) {
                viewModel.micTap()
            }
            .frame(height: 100)

            Spacer()
            
            
        }
        .padding()
        
    }
    
}
