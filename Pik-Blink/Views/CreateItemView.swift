//
//  CreateItemView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData

struct CreateItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = CreateItemViewModel()
    
    var body: some View {
        ZStack {
            // MARK: - Main content
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    GlassIconButton(icon: "x.circle.fill") {
                        if !viewModel.checkPikTextEmpty() {
                            viewModel.showPopup = true
                        } else {
                            dismiss()
                        }
                    }
                    
                    Spacer()
                    
                    GlassIconButton(
                        icon: "square.and.arrow.down",
                        isEnabled: !viewModel.checkPikTextEmpty()
                    ) {
                        if !viewModel.checkPikTextEmpty() {
                            do {
                                try viewModel.savePik()
                                dismiss()
                            } catch {
                                print("Error guardando:", error)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 12)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HeaderView(
                            title: String(localized: "new.item.title"),
                            subtitle: "Capture ideas in a blink."
                        ) {}
                        
                        PikTextField(
                            text: $viewModel.pikItemText,
                            isRecording: viewModel.isRecording
                        ) {
                            viewModel.micTap()
                        }
                        .frame(height: 150)
                        
                        SectionHeader(
                            title: String(localized: "new.item.select.reminder.when.title"),
                            subtitle: String(localized: "new.item.select.reminder.when.description")
                        )
                        
                        HStack(spacing: 17) {
                            ForEach(QuickReminder.allCases, id: \.self) { option in
                                GlassTileButton(
                                    title: option.title,
                                    icon: option.icon,
                                    isSelected: viewModel.selected == option
                                ) {
                                    viewModel.selectReminder(option)
                                }
                            }
                        }
                        
                        if viewModel.selected == .custom {
                            DatePicker(
                                String(localized: "new.item.select.date.time.reminder"),
                                selection: Binding(
                                    get: { viewModel.reminderDate ?? Date() },
                                    set: { viewModel.reminderDate = $0 }
                                ),
                                in: viewModel.dateRange,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                        
                        if viewModel.reminderDate != nil {
                            ReminderSummary(date: viewModel.reminderDate)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top)
            
            // MARK: - Glass popup
            if viewModel.showPopup {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        viewModel.showPopup = false
                    }
                
                GlassPopup(
                    title: String(localized: "new.item.popup.close.title"),
                    subtitle: String(localized: "new.item.popup.close.description"),
                    actions: [
                        GlassPopupAction(title: String(localized: "new.item.popup.close.cancel")) {
                            viewModel.showPopup = false
                        },
                        GlassPopupAction(title: String(localized: "new.item.popup.close.accept"), role: .destructive) {
                            viewModel.showPopup = false
                            dismiss()
                        }
                    ]
                )
                .transition(.scale(scale: 0.95).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.showPopup)
        .onChange(of: viewModel.selected) { _, newValue in
            if newValue == .custom && viewModel.reminderDate == nil {
                viewModel.reminderDate = Date()
            }
        }
        .task {
            viewModel.configure(modelContext: modelContext)
        }
    }
}


#Preview {
    CreateItemView()
}
