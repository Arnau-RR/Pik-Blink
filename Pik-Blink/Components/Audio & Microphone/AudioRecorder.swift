//
//  AudioRecorder.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioRecorder: NSObject, ObservableObject {

    @Published var isRecording = false

    private var recorder: AVAudioRecorder?
    private(set) var lastRecordingPath: String?

    func start() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true)

        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString + ".m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.record()

        lastRecordingPath = url.path
        isRecording = true
    }

    func stop() -> String? {
        recorder?.stop()
        recorder = nil
        isRecording = false
        return lastRecordingPath
    }
}
