import Foundation

/// Where a recording came from. REQ-LIB-001
public enum RecordingSource: String, Codable, Sendable, CaseIterable {
    case teams, zoom, meet, inPerson, importFile, other
}

public enum RecordingStatus: String, Codable, Sendable {
    case recording, finalizing, transcribing, completed, needsRetry
}

/// Separate tracks give reliable Me / Remote attribution. REQ-CAP-001, REQ-TRN-004
public enum TrackKind: String, Codable, Sendable {
    case microphone, system, mixed
}

public struct Track: Codable, Sendable, Identifiable, Equatable {
    public var id: UUID
    public var kind: TrackKind
    public var fileName: String
    /// Offset in seconds relative to recording start, for alignment.
    public var offset: TimeInterval

    public init(id: UUID = UUID(), kind: TrackKind, fileName: String, offset: TimeInterval = 0) {
        self.id = id
        self.kind = kind
        self.fileName = fileName
        self.offset = offset
    }
}

public struct Speaker: Codable, Sendable, Identifiable, Equatable, Hashable {
    public var id: UUID
    public var label: String
    public var isMe: Bool

    public init(id: UUID = UUID(), label: String, isMe: Bool = false) {
        self.id = id
        self.label = label
        self.isMe = isMe
    }

    public static func me() -> Speaker { Speaker(label: "Me", isMe: true) }
    public static func remote() -> Speaker { Speaker(label: "Remote") }
}

public struct Word: Codable, Sendable, Equatable {
    public var start: TimeInterval
    public var end: TimeInterval
    public var text: String
    public var confidence: Double?

    public init(start: TimeInterval, end: TimeInterval, text: String, confidence: Double? = nil) {
        self.start = start
        self.end = end
        self.text = text
        self.confidence = confidence
    }
}

/// A verbatim transcript segment. `originalText` keeps the untouched engine output. REQ-TRN-002, 003, 012
public struct Segment: Codable, Sendable, Identifiable, Equatable {
    public var id: UUID
    public var start: TimeInterval
    public var end: TimeInterval
    public var speakerID: UUID
    public var text: String
    public var originalText: String
    public var words: [Word]
    public var confidence: Double?

    public init(
        id: UUID = UUID(),
        start: TimeInterval,
        end: TimeInterval,
        speakerID: UUID,
        text: String,
        words: [Word] = [],
        confidence: Double? = nil
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.speakerID = speakerID
        self.text = text
        self.originalText = text
        self.words = words
        self.confidence = confidence
    }
}

public struct Recording: Codable, Sendable, Identifiable, Equatable {
    public static let schemaVersion = 1

    public var id: UUID
    public var title: String
    public var startedAt: Date
    public var duration: TimeInterval
    public var source: RecordingSource
    public var status: RecordingStatus
    public var localeIdentifier: String
    public var engine: String?
    public var tracks: [Track]
    public var speakers: [Speaker]
    public var segments: [Segment]

    public init(
        id: UUID = UUID(),
        title: String,
        startedAt: Date,
        duration: TimeInterval = 0,
        source: RecordingSource,
        status: RecordingStatus = .recording,
        localeIdentifier: String = "en-US",
        engine: String? = nil,
        tracks: [Track] = [],
        speakers: [Speaker] = [],
        segments: [Segment] = []
    ) {
        self.id = id
        self.title = title
        self.startedAt = startedAt
        self.duration = duration
        self.source = source
        self.status = status
        self.localeIdentifier = localeIdentifier
        self.engine = engine
        self.tracks = tracks
        self.speakers = speakers
        self.segments = segments
    }

    public func speaker(for id: UUID) -> Speaker? {
        speakers.first { $0.id == id }
    }

    /// Rename propagates to every segment because segments reference speaker IDs. REQ-TRN-010
    public mutating func renameSpeaker(_ id: UUID, to label: String) {
        guard let index = speakers.firstIndex(where: { $0.id == id }) else { return }
        speakers[index].label = label
    }

    /// Segments ordered by start time across tracks.
    public var orderedSegments: [Segment] {
        segments.sorted { ($0.start, $0.end) < ($1.start, $1.end) }
    }
}
