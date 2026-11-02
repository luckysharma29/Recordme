import Foundation

/// Pure state machine for a recording session (design 3.4). REQ-CAP-006
public enum SessionState: String, Codable, Sendable {
    case idle, preparing, recording, paused, recovering, finalizing, transcribing, completed, failed
}

public enum SessionEvent: Sendable {
    case start, sourcesStarted, failure, pause, resume, deviceLost, deviceRecovered, stop, chunksSealed, transcriptionFinished
}

public struct RecordingStateMachine: Sendable {
    public private(set) var state: SessionState = .idle

    public init() {}

    @discardableResult
    public mutating func handle(_ event: SessionEvent) -> Bool {
        let next: SessionState?
        switch (state, event) {
        case (.idle, .start): next = .preparing
        case (.preparing, .sourcesStarted): next = .recording
        case (.preparing, .failure): next = .failed
        case (.recording, .pause): next = .paused
        case (.paused, .resume): next = .recording
        case (.recording, .deviceLost): next = .recovering
        case (.recovering, .deviceRecovered): next = .recording
        case (.recovering, .stop), (.recording, .stop), (.paused, .stop): next = .finalizing
        case (.finalizing, .chunksSealed): next = .transcribing
        case (.transcribing, .transcriptionFinished), (.transcribing, .failure): next = .completed
        default: next = nil
        }
        guard let next else { return false }
        state = next
        return true
    }
}
