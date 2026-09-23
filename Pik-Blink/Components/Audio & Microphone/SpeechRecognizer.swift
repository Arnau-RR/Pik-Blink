//
//  SpeechRecognizer.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Foundation
import Speech
import AVFoundation
import Combine

@MainActor
final class SpeechRecognizer: ObservableObject {

    @Published var transcript = ""

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"))
    private let audioEngine = AVAudioEngine()

    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    func start() async throws {

        let status = await SFSpeechRecognizer.requestAuthorization()

        guard status == .authorized else {
            throw NSError(domain: "Speech", code: 0)
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return }

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)

        input.removeTap(onBus: 0)

        input.installTap(onBus: 0,
                         bufferSize: 1024,
                         format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        task = recognizer?.recognitionTask(with: request) { [weak self] result, _ in
            guard let self else { return }

            if let result {
                self.transcript = result.bestTranscription.formattedString
            }
        }
    }

    func stop() async -> String {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        request?.endAudio()

        return await withCheckedContinuation { continuation in
            task?.finish()

            task = nil
            request = nil

            continuation.resume(returning: transcript)
        }
    }
}

extension SFSpeechRecognizer {

    static func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            requestAuthorization {
                continuation.resume(returning: $0)
            }
        }
    }
}
