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
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(
                        title: String(localized: "new.item.title"),
                        subtitle: "Capture ideas in a blink."
                    ) {}
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        PikTextField(
                            text: $viewModel.pikItemText,
                            isRecording: viewModel.isRecording
                        ) {
                            viewModel.micTap()
                        }
                        
                        .frame(height: 150)
                        
                        SectionHeader(
                            title: String(localized: "new.item.select.reminder.title"),
                            subtitle: String(localized: "new.item.select.reminder.description")
                        )
                        
                        Picker("", selection: $viewModel.selectedTab) {
                            Label(String(localized: "new.item.picker.when"), systemImage: "clock")
                                .tag(0)
                            
                            Label(String(localized: "new.item.picker.where"), systemImage: "checkmark.circle")
                                .tag(1)
                            
                        }
                        .pickerStyle(.segmented)
                        .labelStyle(.titleAndIcon)
                        
                        ReminderBox {
                            VStack (spacing: 15){
                                HStack (spacing: 10){
                                    
                                    Image(systemName: "clock")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    
                                    SectionHeader(
                                        title: String(localized: "new.item.select.reminder.when.title"),
                                        subtitle: String(localized: "new.item.select.reminder.when.description"),
                                        titleFont: .system(size: 15),
                                        subtitleFont: .footnote
                                    )
                                }
                                
                                HStack(spacing: 5) {
                                    ForEach(QuickReminder.allCases, id: \.self) { option in
                                        GlassTileButton(
                                            title: option.title,
                                            icon: option.icon,
                                            isSelected: viewModel.selected == option,
                                            backgroundColor: Color(.systemBackground)
                                        ) {
                                            viewModel.selectReminder(option)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                                if viewModel.selected == .custom {
                                    DateTimeCard(
                                        date: viewModel.reminderDate
                                    ) {
                                        viewModel.showDatePicker = true
                                    }
                                }
                            }
                        }
                        
                        if viewModel.selected != .custom && viewModel.reminderDate != nil {
                            ReminderSummary(date: viewModel.reminderDate)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "new.item.popup.close.cancel")) {
                    if !viewModel.checkPikTextEmpty() {
                        viewModel.showPopup = true
                    } else {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "new.item.popup.close.accept")) {
                    do {
                        try viewModel.savePik()
                        dismiss()
                    } catch {
                        print("Error guardando:", error)
                    }
                }
                .fontWeight(.semibold)
                .disabled(viewModel.checkPikTextEmpty())
                .opacity(viewModel.checkPikTextEmpty() ? 0.4 : 1.0)
            }
        }
        .task {
            viewModel.configure(modelContext: modelContext)
        }
        .sheet(isPresented: $viewModel.showDatePicker) {
            customDateAndHourSheetView
                .presentationDetents([.height(470)])
                .presentationDragIndicator(.visible)
        }
    }
}

extension CreateItemView {
    
    private var customDateAndHourSheetView: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.reminderDate ?? Date() },
                        set: { viewModel.reminderDate = $0 }
                    ),
                    in: viewModel.dateRange,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
            }
            .padding()
            .navigationTitle("new.item.popup.date.time.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(localized: "new.item.popup.close.cancel")) {
                        viewModel.showDatePicker = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "new.item.popup.close.accept")) {
                        viewModel.showDatePicker = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}


#Preview {
    CreateItemView()
}
