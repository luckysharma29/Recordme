import XCTest
@testable import RecordmeCore

final class ExporterTests: XCTestCase {
    private func sample() -> Recording {
        let me = Speaker.me()
        let remote = Speaker.remote()
        return Recording(
            title: "Weekly sync",
            startedAt: Date(timeIntervalSince1970: 0),
            duration: 3723.5,
            source: .teams,
            status: .completed,
            speakers: [me, remote],
            segments: [
                Segment(start: 5.25, end: 8.0, speakerID: remote.id, text: "Can you hear me?"),
                Segment(start: 1.0, end: 4.5, speakerID: me.id, text: "Hi everyone."),
            ]
        )
    }

    func test_REQ_EXP_001_txtIsOrderedAndLabelled() {
        let txt = TranscriptExporter.plainText(sample())
        XCTAssertEqual(txt, "[00:00:01] Me: Hi everyone.\n[00:00:05] Remote: Can you hear me?\n")
    }

    func test_REQ_EXP_001_srtTimestamps() {
        let srt = TranscriptExporter.srt(sample())
        XCTAssertTrue(srt.hasPrefix("1\n00:00:01,000 --> 00:00:04,500\nMe: Hi everyone.\n"))
        XCTAssertTrue(srt.contains("2\n00:00:05,250 --> 00:00:08,000\nRemote: Can you hear me?"))
    }

    func test_REQ_EXP_001_vttVoiceTags() {
        let vtt = TranscriptExporter.webVTT(sample())
        XCTAssertTrue(vtt.hasPrefix("WEBVTT\n\n"))
        XCTAssertTrue(vtt.contains("00:00:05.250 --> 00:00:08.000\n<v Remote>Can you hear me?"))
    }

    func test_REQ_EXP_001_jsonRoundTripsSegments() throws {
        let json = try TranscriptExporter.json(sample())
        XCTAssertTrue(json.contains("\"schemaVersion\" : 1"))
        XCTAssertTrue(json.contains("Can you hear me?"))
    }

    func test_REQ_TRN_010_renamePropagates() {
        var r = sample()
        let remoteID = r.speakers[1].id
        r.renameSpeaker(remoteID, to: "Priya")
        XCTAssertTrue(TranscriptExporter.plainText(r).contains("Priya: Can you hear me?"))
    }

    func test_REQ_TRN_002_mergeKeepsTextVerbatim() {
        let a = [Segment(start: 2, end: 3, speakerID: UUID(), text: "um, so yeah")]
        let b = [Segment(start: 1, end: 2, speakerID: UUID(), text: "uh huh")]
        let merged = TranscriptMerger.merge([a, b])
        XCTAssertEqual(merged.map(\.text), ["uh huh", "um, so yeah"])
    }

    func test_clockFormatHours() {
        XCTAssertEqual(TimeFormat.clock(3723.5), "01:02:03")
        XCTAssertEqual(TimeFormat.srt(3723.5), "01:02:03,500")
    }
}

final class StateMachineTests: XCTestCase {
    func test_REQ_CAP_006_pauseResumeStop() {
        var sm = RecordingStateMachine()
        XCTAssertTrue(sm.handle(.start))
        XCTAssertTrue(sm.handle(.sourcesStarted))
        XCTAssertTrue(sm.handle(.pause))
        XCTAssertEqual(sm.state, .paused)
        XCTAssertTrue(sm.handle(.resume))
        XCTAssertTrue(sm.handle(.stop))
        XCTAssertEqual(sm.state, .finalizing)
    }

    func test_invalidTransitionRejected() {
        var sm = RecordingStateMachine()
        XCTAssertFalse(sm.handle(.pause))
        XCTAssertEqual(sm.state, .idle)
    }
}
