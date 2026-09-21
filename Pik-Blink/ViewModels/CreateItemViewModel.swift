//
//  CreateItemViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

//
//  CreateItemViewModel.swift
//  Pik-Blink
//

import Combine
import Foundation

@MainActor
final class CreateItemViewModel: ObservableObject {

    @Published var pikItem = ""
    @Published var selectedTab = 0

    @Published var isRecording = false
    @Published var audioPath: String?

    private let audio = AudioRecorder()
    private let speech = SpeechRecognizer()
    private var cancellables = Set<AnyCancellable>()

    /// Texto que ya existía antes de empezar una nueva grabación
    private var baseText = ""

    init() {
        speech.$transcript
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transcript in
                guard let self else { return }

                if self.baseText.isEmpty {
                    self.pikItem = transcript
                } else if transcript.isEmpty {
                    self.pikItem = self.baseText
                } else {
                    self.pikItem = self.baseText + " " + transcript
                }
            }
            .store(in: &cancellables)
    }

    func micTap() {

        if isRecording {

            audioPath = audio.stop()

            Task {
                _ = await speech.stop()
                isRecording = false
            }

        } else {

            // Guardamos el texto actual para no perderlo
            baseText = pikItem

            Task {
                try? audio.start()
                try? await speech.start()
                isRecording = true
            }
        }
    }
}
