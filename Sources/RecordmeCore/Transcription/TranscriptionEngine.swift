import Foundation

public struct EngineID: RawRepresentable, Hashable, Codable, Sendable {
    public var rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let speechAnalyzer = EngineID(rawValue: "apple.speechanalyzer")
    public static let whisperKit = EngineID(rawValue: "whisperkit")
}

public struct TranscriptionOptions: Sendable {
    public var localeIdentifier: String?   // nil = auto-detect. REQ-TRN-005
    public var speakerID: UUID
    public var wordTimestamps: Bool
    public var customVocabulary: [String]  // REQ-TRN-011

    public init(localeIdentifier: String? = "en-US", speakerID: UUID, wordTimestamps: Bool = true, customVocabulary: [String] = []) {
        self.localeIdentifier = localeIdentifier
        self.speakerID = speakerID
        self.wordTimestamps = wordTimestamps
        self.customVocabulary = customVocabulary
    }
}

/// Pluggable on-device engine (ADR 0003). Implementations live in the app targets
/// because they depend on Apple-only frameworks (Speech, CoreML).
public protocol TranscriptionEngine: Sendable {
    var id: EngineID { get }
    func supports(localeIdentifier: String) async -> Bool
    func prepare(localeIdentifier: String) async throws
    func transcribe(file: URL, options: TranscriptionOptions) -> AsyncThrowingStream<Segment, Error>
}
