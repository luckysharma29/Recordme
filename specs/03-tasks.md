# Recordme Implementation Plan

Each task lists the requirements it satisfies. A task is done when its acceptance tests pass and the requirement row is ticked.

## Milestone 0: Foundations (week 1)

| ID | Task | Traces to | Status |
| --- | --- | --- | --- |
| T-00-01 | Repo, specs, ADRs, XcodeGen project, Swift package skeleton | all | Done |
| T-00-02 | Core domain model (`Recording`, `Track`, `Segment`, `Word`, `Speaker`) | REQ-TRN-003 | Done (scaffold) |
| T-00-03 | Exporters TXT/MD/SRT/VTT/JSON + tests | REQ-EXP-001 | Done (scaffold) |
| T-00-04 | CI: GitHub Actions `swift test` (core done), `xcodebuild` app builds (todo) | NFR-10 | In progress |

## Milestone 1: macOS MVP capture (weeks 2 to 3)

| ID | Task | Traces to |
| --- | --- | --- |
| T-01-01 | `MicSource` with AVAudioEngine | REQ-CAP-001 |
| T-01-02 | `CoreAudioTapSource` (process taps, per-app scope) | REQ-CAP-001, 002 |
| T-01-03 | `ScreenCaptureKitSource` fallback | REQ-CAP-001 |
| T-01-04 | `ChunkedAudioWriter` + manifest + `RecoveryService` | REQ-CAP-003, NFR-04 |
| T-01-05 | `RecordingSession` state machine with pause/resume | REQ-CAP-006 |
| T-01-06 | Menu bar UI with indicator and levels | REQ-CAP-005 |
| T-01-07 | Permission onboarding + first-run consent notice | REQ-PRV-001, 003 |

## Milestone 2: Transcription MVP (weeks 3 to 4)

| ID | Task | Traces to |
| --- | --- | --- |
| T-02-01 | `TranscriptionEngine` protocol + `SpeechAnalyzerEngine` | REQ-TRN-001, 002, 005 |
| T-02-02 | `WhisperKitEngine` fallback with model download + checksum | REQ-TRN-001, NFR-07 |
| T-02-03 | Per-track transcription, Me/Remote attribution, merger | REQ-TRN-003, 004 |
| T-02-04 | Persistent `TranscriptionQueue` | REQ-TRN-009 |
| T-QA-01 | WER benchmark set (10 h of call + room audio) and harness | NFR-03 |

## Milestone 3: Library (weeks 4 to 5)

| ID | Task | Traces to |
| --- | --- | --- |
| T-03-01 | GRDB store + FTS5 search | REQ-LIB-001, 003 |
| T-03-02 | Library window, synced player + transcript | REQ-LIB-002 |
| T-03-03 | Speaker rename, delete recording | REQ-TRN-010, REQ-LIB-005 |
| T-03-04 | Export UI, share sheet, drag-and-drop | REQ-EXP-002, 003 |

**MVP release gate (macOS):** M1 to M3 complete, NFR-01/02/03/04 measured and met.

## Milestone 4: iOS app (weeks 6 to 8)

| ID | Task | Traces to |
| --- | --- | --- |
| T-04-01 | iOS recorder, background audio, interruptions | REQ-CAP-004, C-4 |
| T-04-02 | Live Activity + stop App Intent | REQ-CAP-005 |
| T-04-03 | Import via Share extension / Files | REQ-CAP-010 |
| T-04-04 | iOS library, player, export (shared views) | REQ-LIB-*, REQ-EXP-* |
| T-04-05 | Battery and performance tuning | NFR-06 |

## Milestone 5: v1.0 (weeks 9 to 12)

| ID | Task | Traces to |
| --- | --- | --- |
| T-05-01 | `MeetingDetector` + auto start/stop | REQ-CAP-007, 008 |
| T-05-02 | Device change handling | REQ-CAP-009 |
| T-05-03 | Live transcript + final pass | REQ-TRN-006, 007 |
| T-05-04 | On-device diarisation | REQ-TRN-008 |
| T-05-05 | CloudKit sync + deferred transcription on Mac | REQ-SYN-001, 002 |
| T-05-06 | Auto-title from calendar | REQ-LIB-004 |
| T-05-07 | App lock, data protection, consent message | REQ-PRV-004, 005, 006 |
| T-05-08 | Notarised DMG + Sparkle, TestFlight | NFR-09 |

## Backlog (Could)

REQ-CAP-011 (ReplayKit spike), REQ-CAP-012, REQ-TRN-011, REQ-TRN-012, REQ-LIB-006, REQ-EXP-004, REQ-SYN-003 (S3 backup), REQ-PRV-007.
