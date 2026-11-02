import Foundation

/// Interleaves per-track transcripts into one timeline. Text is never altered. REQ-TRN-002, 004
public enum TranscriptMerger {
    public static func merge(_ tracks: [[Segment]]) -> [Segment] {
        tracks.flatMap { $0 }.sorted { ($0.start, $0.end) < ($1.start, $1.end) }
    }
}
