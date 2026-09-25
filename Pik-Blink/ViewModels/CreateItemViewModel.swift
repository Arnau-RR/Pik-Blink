//
//  CreateItemViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Combine
import Foundation
import SwiftData
internal import MapKit

enum SavePikError: Error {
    case missingModelContext
}

enum Field {
    case title
}

@MainActor
final class CreateItemViewModel: ObservableObject {
    
    static let shared = CreateItemViewModel()

    @Published var pikItemText = ""
    @Published var selectedTab = 0

    @Published var isRecording = false
    @Published var audioPath: String?
    
    @Published var selected: QuickReminder? = nil
    @Published var reminderDate: Date? = nil
    
    @Published var showCalendar: Bool = false
    @Published var showTime: Bool = false
    @Published var showPopup = false
    
    @Published var showDatePicker = false
    @Published var showPlacePicker = false
    
    @Published var searchBarText = ""
    
    @Published var search = LocationSearchService()
    @Published var selectedPlace: SelectedPlace?

    private let audio = AudioRecorder()
    private let speech = SpeechRecognizer()
    private let notifications = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()
        
    let dateRange: PartialRangeFrom<Date> = Calendar.current.startOfDay(for: .now)...

    /// Texto que ya existía antes de empezar una nueva grabación
    private var baseText = ""
    
    private var modelContext: ModelContext?

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    init() {
        speech.$transcript
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transcript in
                guard let self else { return }

                if self.baseText.isEmpty {
                    self.pikItemText = transcript
                } else if transcript.isEmpty {
                    self.pikItemText = self.baseText
                } else {
                    self.pikItemText = self.baseText + " " + transcript
                }
            }
            .store(in: &cancellables)
    }
    
    func saveMockPik() throws {
        guard let modelContext else {
            throw SavePikError.missingModelContext
        }

        let mockItem = PikItem(
            text: "Comprar café y leche",
            transcription: nil,
            audioPath: nil,
            reminderType: .date,
            remindAt: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            placeName: nil,
            placeAddress: nil,
            latitude: nil,
            longitude: nil,
            source: .text,
            status: .pending
        )

        modelContext.insert(mockItem)
        try modelContext.save()

        // Programar la notificación del mock
        //notifications.schedule(for: mockItem)
    }
    
    func checkPikTextEmpty() -> Bool {
        return pikItemText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    func micTap() {
        if isRecording {
            audioPath = audio.stop()
            Task {
                _ = await speech.stop()
                isRecording = false
            }
        } else {
            baseText = pikItemText
            Task {
                try? audio.start()
                try? await speech.start()
                isRecording = true
            }
        }
    }
    
    func updateCustomDate(_ date: Date) {
        reminderDate = date
    }
    
    func selectReminder(_ option: QuickReminder) {

        // Toggle
        if selected == option {
            selected = nil
            reminderDate = nil
            return
        }

        selected = option

        let calendar = Calendar.current

        switch option {

        case .thirtyMinutes:
            reminderDate = calendar.date(
                byAdding: .minute,
                value: 30,
                to: .now
            )

        case .oneHour:
            reminderDate = calendar.date(
                byAdding: .hour,
                value: 1,
                to: .now
            )

        case .twoHours:
            reminderDate = calendar.date(
                byAdding: .hour,
                value: 2,
                to: .now
            )

        case .custom:
            reminderDate = nil
        }
    }
    
    func didChangeTab(to tab: Int) {
        if tab == 0 {
            // Cambia a "Cuando" → borrar ubicación
            selectedPlace = nil
            search.query = ""
        } else {
            // Cambia a "Dónde" → borrar fecha
            selected = nil
            reminderDate = nil
        }
    }

    
    @MainActor
    func savePikLocal() throws {
        try savePik(
            text: pikItemText,
            reminderDate: reminderDate,
            selectedPlace: selectedPlace,
            audioPath: audioPath,
            source: audioPath == nil ? .text : .voice
        )
    }
//    func savePik() throws {
//        guard let modelContext else {
//            throw SavePikError.missingModelContext
//        }
//
//        let type: ReminderType
//
//        if selectedPlace != nil {
//            type = .location
//        } else if reminderDate != nil {
//            type = .date
//        } else {
//            type = .none
//        }
//
//        let item = PikItem(
//            text: pikItemText.trimmingCharacters(in: .whitespacesAndNewlines),
//            transcription: audioPath != nil ? pikItemText : nil,
//            audioPath: audioPath,
//
//            reminderType: type,
//            remindAt: type == .date ? reminderDate : nil,
//
//            placeName: type == .location ? selectedPlace?.name : nil,
//            placeAddress: type == .location ? selectedPlace?.address : nil,
//            latitude: type == .location ? selectedPlace?.coordinate.latitude : nil,
//            longitude: type == .location ? selectedPlace?.coordinate.longitude : nil,
//
//            source: audioPath == nil ? .text : .voice,
//            status: .pending
//        )
//
//        // Guardar en SwiftData
//        modelContext.insert(item)
//        try modelContext.save()
//
//        // Pedir permiso de ubicación si hace falta
//        if type == .location {
//            notifications.requestLocationPermission()
//        }
//
//        // Programar la notificación
//        notifications.schedule(for: item)
//    }
    
    @MainActor
    func savePik(
        text: String,
        reminderDate: Date?,
        selectedPlace: SelectedPlace?,
        audioPath: String? = nil,
        source: PikSource = .text
    ) throws {

        guard let modelContext else {
            throw SavePikError.missingModelContext
        }

        let type: ReminderType =
            selectedPlace != nil ? .location :
            reminderDate != nil ? .date : .none

        let item = PikItem(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            transcription: audioPath != nil ? text : nil,
            audioPath: audioPath,
            reminderType: type,
            remindAt: type == .date ? reminderDate : nil,
            placeName: type == .location ? selectedPlace?.name : nil,
            placeAddress: type == .location ? selectedPlace?.address : nil,
            latitude: type == .location ? selectedPlace?.coordinate.latitude : nil,
            longitude: type == .location ? selectedPlace?.coordinate.longitude : nil,
            source: source,
            status: .pending
        )

        modelContext.insert(item)
        try modelContext.save()

        if type == .location {
            notifications.requestLocationPermission()
        }

        notifications.schedule(for: item)
    }
    
//    @MainActor
//    func savePik() throws {
//        guard let modelContext else {
//            throw SavePikError.missingModelContext
//        }
//        
//        let type: ReminderType
//
//        if selectedPlace != nil {
//            type = .location
//        } else if reminderDate != nil {
//            type = .date
//        } else {
//            type = .none
//        }
//
//        let item = PikItem(
//            text: pikItemText.trimmingCharacters(in: .whitespacesAndNewlines),
//            transcription: isRecording ? pikItemText : nil,
//            audioPath: audioPath,
//
//            reminderType: type,
//            remindAt: type == .date ? reminderDate : nil,
//
//            placeName: type == .location ? selectedPlace?.name : nil,
//            placeAddress: type == .location ? selectedPlace?.address : nil,
//            latitude: type == .location ? selectedPlace?.coordinate.latitude : nil,
//            longitude: type == .location ? selectedPlace?.coordinate.longitude : nil,
//
//            source: audioPath == nil ? .text : .voice,
//            status: .pending
//        )
//        
//        modelContext.insert(item)
//        try modelContext.save()
//    }
    

    @MainActor
    func selectCompletion(_ completion: MKLocalSearchCompletion) {
        Task {
            do {
                let place = try await search.resolve(completion)
                selectedPlace = place
                showPlacePicker = false
            } catch {
                print(error)
            }
        }
    }
}
