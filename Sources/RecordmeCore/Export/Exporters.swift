import Foundation

/// Transcript export formats. REQ-EXP-001
public enum ExportFormat: String, CaseIterable, Sendable {
    case txt, markdown = "md", srt, vtt, json

    public var fileExtension: String { rawValue }
}

public enum TranscriptExporter {
    public static func export(_ recording: Recording, as format: ExportFormat) throws -> String {
        switch format {
        case .txt: return plainText(recording)
        case .markdown: return markdown(recording)
        case .srt: return srt(recording)
        case .vtt: return webVTT(recording)
        case .json: return try json(recording)
        }
    }

    // MARK: Formats

    public static func plainText(_ r: Recording) -> String {
        r.orderedSegments.map { "[\(TimeFormat.clock($0.start))] \(label(r, $0)): \($0.text)" }
            .joined(separator: "\n") + "\n"
    }

    public static func markdown(_ r: Recording) -> String {
        var out = "# \(r.title)\n\n"
        out += "| Field | Value |\n| --- | --- |\n"
        out += "| Date | \(ISO8601DateFormatter().string(from: r.startedAt)) |\n"
        out += "| Duration | \(TimeFormat.clock(r.duration)) |\n"
        out += "| Source | \(r.source.rawValue) |\n"
        out += "| Language | \(r.localeIdentifier) |\n\n"
        for s in r.orderedSegments {
            out += "**\(label(r, s))** (\(TimeFormat.clock(s.start))): \(s.text)\n\n"
        }
        return out
    }

    public static func srt(_ r: Recording) -> String {
        r.orderedSegments.enumerated().map { index, s in
            "\(index + 1)\n\(TimeFormat.srt(s.start)) --> \(TimeFormat.srt(s.end))\n\(label(r, s)): \(s.text)\n"
        }.joined(separator: "\n")
    }

    public static func webVTT(_ r: Recording) -> String {
        var out = "WEBVTT\n\n"
        out += r.orderedSegments.map { s in
            "\(TimeFormat.vtt(s.start)) --> \(TimeFormat.vtt(s.end))\n<v \(label(r, s))>\(s.text)\n"
        }.joined(separator: "\n")
        return out
    }

    public static func json(_ r: Recording) throws -> String {
        struct Envelope: Encodable {
            let schemaVersion: Int
            let recording: Recording
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(Envelope(schemaVersion: Recording.schemaVersion, recording: r))
        return String(decoding: data, as: UTF8.self)
    }

    private static func label(_ r: Recording, _ s: Segment) -> String {
        r.speaker(for: s.speakerID)?.label ?? "Unknown"
    }
}

public enum TimeFormat {
    private static func parts(_ t: TimeInterval) -> (h: Int, m: Int, s: Int, ms: Int) {
        let totalMs = Int((max(0, t) * 1000).rounded())
        return (totalMs / 3_600_000, (totalMs / 60_000) % 60, (totalMs / 1000) % 60, totalMs % 1000)
    }

    /// 01:02:03
    public static func clock(_ t: TimeInterval) -> String {
        let p = parts(t)
        return String(format: "%02d:%02d:%02d", p.h, p.m, p.s)
    }

    /// 01:02:03,456
    public static func srt(_ t: TimeInterval) -> String {
        let p = parts(t)
        return String(format: "%02d:%02d:%02d,%03d", p.h, p.m, p.s, p.ms)
    }

    /// 01:02:03.456
    public static func vtt(_ t: TimeInterval) -> String {
        let p = parts(t)
        return String(format: "%02d:%02d:%02d.%03d", p.h, p.m, p.s, p.ms)
    }
}
