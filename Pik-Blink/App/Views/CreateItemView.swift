//
//  CreateItemView.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import SwiftUI
import SwiftData
import MapKit

struct CreateItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FavoritePlace.name)
    private var favoritePlaces: [FavoritePlace]
    
    let itemToEdit: PikItem?

    init(itemToEdit: PikItem? = nil) {
        self.itemToEdit = itemToEdit
    }
    
    @FocusState private var focusedField: Field?
    
    @StateObject private var viewModel = CreateItemViewModel()
    
    var body: some View {
        ZStack {
            // MARK: - Main content
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(
                        title: "new.item.title",
                        subtitle: "Capture ideas in a blink."
                    ) {}
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        PikTextField(
                            text: $viewModel.pikItemText,
                            isRecording: viewModel.isRecording,
                            focusedField: $focusedField
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
                        .onChange(of: viewModel.selectedTab) { _, newValue in
                            viewModel.didChangeTab(to: newValue)
                        }
                        
                        if viewModel.selectedTab == 0 {
                            selectWhenPickerView
                        } else {
                            selectWherePickerView
                        }
                        
                        
                        if viewModel.selected != .custom && viewModel.reminderDate != nil {
                            ReminderSummary(date: viewModel.reminderDate)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .scrollDismissesKeyboard(.interactively)
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
        .onTapGesture {
            focusedField = nil
        }
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
                        try viewModel.savePikLocal()
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
            
            if let itemToEdit {
                viewModel.load(item: itemToEdit)
            }
        }
        .sheet(isPresented: $viewModel.showDatePicker) {
            NavigationStack {
                customDateAndHourSheetView
            }
            .presentationDetents([.height(520)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showPlacePicker) {
            customSelectLocationView
                .presentationDetents([.height(520)])
                .presentationDragIndicator(.visible)
        }
    }
}

extension CreateItemView {
    
    private var selectWhenPickerView: some View {
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
    }
    
    private var selectWherePickerView: some View {
        ReminderBox {
            VStack(spacing: 15) {
                HStack(spacing: 10) {
                    Image(systemName: "location.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    
                    SectionHeader(
                        title: String(localized: "new.item.select.reminder.where.title"),
                        subtitle: String(localized: "new.item.select.reminder.where.description"),
                        titleFont: .system(size: 15),
                        subtitleFont: .footnote
                    )
                }
                
                Button {
                    viewModel.showPlacePicker = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.55))
                        
                        Text(String(localized: "new.item.select.reminder.where.search.place.button"))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.85))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.35))
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.22, green: 0.22, blue: 0.24))
                    )
                }
                .buttonStyle(.plain)
                
                HStack(spacing: 10) {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    SectionHeader(
                        title: String(localized: "new.item.select.reminder.where.favoutire.title"),
                        subtitle: String(localized: "new.item.select.reminder.where.favoutire.description"),
                        titleFont: .system(size: 12),
                        subtitleFont: .footnote
                    )
                }
                
                // FAVORITOS
                if favoritePlaces.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "star")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        Text("new.item.popup.location.favourites.description.add.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                } else {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(favoritePlaces) { place in
                                GlassTextButton(
                                    title: place.label,
                                    isSelected: viewModel.selectedPlace?.name == place.name,
                                    backgroundColor: Color(.systemBackground)
                                ) {
                                    viewModel.selectFavorite(place)
                                }
                            }
                        }
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let place = viewModel.selectedPlace {
                    PlaceCard(place: place)
                        .id(place.id)
                }
            }
        }
    }
    
    private var customDateAndHourSheetView: some View {
        ReusableSheet(
            title: "new.item.popup.date.time.title",
            onCancel: {
                viewModel.showDatePicker = false
            },
            onAccept: {
                viewModel.showDatePicker = false
            }
        ) {
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
            
            Spacer()
        }
    }
    
    private var customSelectLocationView: some View {
        ReusableSheet(
            title: "new.item.popup.location.title",
            onCancel: {
                viewModel.showPlacePicker = false
            },
            onAccept: {
                viewModel.showPlacePicker = false
            }
        ) {
            List {
                ForEach(viewModel.search.results, id: \.self) { item in
                    Button {
                        viewModel.selectCompletion(item)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.headline)
                            
                            if !item.subtitle.isEmpty {
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
            .searchable(
                text: $viewModel.search.query,
                prompt: "new.item.popup.location.search.place.button"
            )
        }
    }
}


#Preview {
    CreateItemView()
}
