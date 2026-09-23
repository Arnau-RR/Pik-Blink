//
//  CreateItemViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Combine
import Foundation
import SwiftData

enum SavePikError: Error {
    case missingModelContext
}

@MainActor
final class CreateItemViewModel: ObservableObject {

    @Published var pikItemText = ""
    @Published var selectedTab = 0

    @Published var isRecording = false
    @Published var audioPath: String?
    
    @Published var selected: QuickReminder? = nil
    @Published var reminderDate: Date? = nil
    
    @Published var showCalendar: Bool = false
    @Published var showTime: Bool = false
    @Published var showPopup = false

    private let audio = AudioRecorder()
    private let speech = SpeechRecognizer()
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

    @MainActor
    func savePik() throws {
        guard let modelContext else {
            throw SavePikError.missingModelContext
        }

        let item = PikItem(
            text: pikItemText.trimmingCharacters(in: .whitespacesAndNewlines),
            transcription: isRecording ? pikItemText : nil,
            audioPath: audioPath,
            remindAt: reminderDate,
            source: audioPath == nil ? .text : .voice
        )

        modelContext.insert(item)
        try modelContext.save()
    }}
