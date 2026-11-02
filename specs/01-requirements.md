# Recordme Requirements Specification

Version 0.1 (draft for alignment) · Status: **Awaiting sign-off** · Notation: EARS (Easy Approach to Requirements Syntax)

## 1. Problem statement

Knowledge workers spend much of their day in Teams, Zoom and Google Meet calls and in-person meetings. Existing tools (Plaud Note, Meetily, Otter, Granola) bundle recording with AI summaries, cloud upload and bot participants. The user wants a **simple, private recorder that produces an accurate raw transcript** on the devices they already own: a MacBook and an iPhone.

## 2. Goals and non-goals

### Goals
* G1. One-click (or automatic) recording of Teams, Zoom and Google Meet calls on macOS without a bot joining the meeting.
* G2. Recording of in-person meetings on Mac and iPhone.
* G3. Accurate, timestamped, speaker-attributed raw transcript produced on-device.
* G4. Recordings and transcripts available on both devices.
* G5. Export to common text and subtitle formats.

### Non-goals (explicitly out of scope)
* NG1. AI summaries, action items, chat-with-transcript, translation, sentiment, "smart notes".
* NG2. Meeting bots that join calls as a participant.
* NG3. Hardware recorder device (Plaud style). Software only.
* NG4. Windows, Android, web app (may be revisited later).
* NG5. Video recording.

## 3. Personas and primary scenarios

| ID | Scenario |
| --- | --- |
| SC-1 | On a MacBook, the user joins a Teams/Zoom/Meet call. Recordme detects it, offers "Record", captures both sides, and produces a transcript minutes after the call ends. |
| SC-2 | In a meeting room, the user taps Record on iPhone (or Mac), places the phone on the table, and gets a transcript later. |
| SC-3 | On iPhone, the user is on a Teams/Zoom call. They start a recording and get as much of the conversation as the platform legitimately allows (see 6. Platform constraints). |
| SC-4 | The user opens a past recording on either device, searches text, plays audio from a clicked word, corrects a speaker label, and exports SRT/TXT. |

## 4. Functional requirements

Priority: **M** = Must (MVP), **S** = Should (v1.0), **C** = Could (later).

### 4.1 Capture (CAP)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-CAP-001 | M | When the user starts a recording on macOS, the system shall capture microphone audio and system output audio as two separate tracks. |
| REQ-CAP-002 | M | Where the user selects an app scope (Teams, Zoom, a browser for Meet), the macOS system shall capture output audio only from those processes. |
| REQ-CAP-003 | M | The system shall write audio to disk in chunks of at most 10 seconds so that no more than 10 seconds of audio is lost on crash or power loss. |
| REQ-CAP-004 | M | When the user starts a recording on iOS, the system shall capture microphone audio, continuing while the app is in the background or the screen is locked. |
| REQ-CAP-005 | M | While recording, the system shall show a persistent visible indicator (menu bar item on macOS, Live Activity / Dynamic Island on iOS) with elapsed time and input levels. |
| REQ-CAP-006 | M | The system shall allow pause, resume and stop, and shall support recordings of at least 4 hours. |
| REQ-CAP-007 | S | When a Teams, Zoom or Meet call becomes active on macOS, the system shall notify the user and offer to start recording (auto-start configurable per app). |
| REQ-CAP-008 | S | When the call that triggered a recording ends, the system shall stop the recording automatically after a configurable grace period (default 30 s). |
| REQ-CAP-009 | S | If the active input or output device changes (for example AirPods connect), the system shall continue recording on the new device without user action. |
| REQ-CAP-010 | S | On iOS, the system shall import audio files (iOS Phone call recordings, Voice Memos, any m4a/wav/mp3) via Share Sheet and Files and transcribe them. |
| REQ-CAP-011 | C | On iOS, the system shall offer a ReplayKit broadcast capture mode that records app audio plus mic where iOS permits it (experimental, see C-3). |
| REQ-CAP-012 | C | The system shall support global keyboard shortcut and Shortcuts/Siri actions to start and stop recording. |

### 4.2 Transcription (TRN)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-TRN-001 | M | The system shall transcribe recordings entirely on-device with no network dependency. |
| REQ-TRN-002 | M | The transcript shall be verbatim engine output, without summarisation, paraphrasing or content filtering (Constitution 1). |
| REQ-TRN-003 | M | Each transcript segment shall carry start time, end time, speaker label and text; word-level timestamps shall be kept where the engine provides them. |
| REQ-TRN-004 | M | The system shall attribute segments from the mic track to "Me" and from the system audio track to "Remote" on macOS calls. |
| REQ-TRN-005 | M | The system shall support at least English, and shall let the user choose the recognition language per recording or use auto-detect. |
| REQ-TRN-006 | S | While recording, the system shall display a live transcript with latency under 5 seconds on Apple Silicon. |
| REQ-TRN-007 | S | After recording stops, the system shall run a final high-accuracy pass and replace the live transcript. |
| REQ-TRN-008 | S | The system shall offer optional on-device diarisation to split "Remote" (and in-room recordings) into Speaker 1..N. |
| REQ-TRN-009 | S | The user shall be able to re-transcribe a recording with a different engine, model or language. |
| REQ-TRN-010 | S | The user shall be able to rename speakers; renames propagate to all segments of that speaker. |
| REQ-TRN-011 | C | The user shall be able to add a custom vocabulary (names, acronyms) to bias recognition. |
| REQ-TRN-012 | C | The user shall be able to manually edit segment text; the original engine text is retained for audit. |

### 4.3 Library and playback (LIB)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-LIB-001 | M | The system shall list recordings with title, date, duration, source (Teams/Zoom/Meet/In-person/Import) and transcription status. |
| REQ-LIB-002 | M | The system shall play audio synchronised with the transcript; tapping a segment seeks playback to it. |
| REQ-LIB-003 | M | The system shall provide full-text search across all transcripts. |
| REQ-LIB-004 | S | The system shall auto-title recordings from the calendar event (if calendar access granted) or the meeting app window title. |
| REQ-LIB-005 | S | The user shall be able to delete a recording, removing audio, transcript and synced copies. |
| REQ-LIB-006 | C | The user shall be able to tag and folder recordings. |

### 4.4 Export (EXP)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-EXP-001 | M | The system shall export a transcript as TXT, Markdown, SRT, WebVTT and JSON. |
| REQ-EXP-002 | M | The system shall export the audio as M4A (AAC) with an option for separate per-track files. |
| REQ-EXP-003 | S | Export shall be available through the share sheet on both platforms and drag-and-drop on macOS. |
| REQ-EXP-004 | C | The system shall auto-export transcripts to a user-chosen folder (for example an Obsidian vault). |

### 4.5 Sync (SYN)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-SYN-001 | S | Where iCloud sync is enabled, recordings and transcripts shall appear on all of the user's devices signed into the same Apple ID. |
| REQ-SYN-002 | S | Where sync is enabled, an iPhone recording may be transcribed on the Mac if the user prefers higher-accuracy models (deferred transcription). |
| REQ-SYN-003 | C | Where the user configures it, the system shall back up encrypted recordings to an S3-compatible bucket they own (for example AWS S3). |

### 4.6 Privacy, consent and compliance (PRV)

| ID | Pri | Requirement |
| --- | --- | --- |
| REQ-PRV-001 | M | The system shall request only the permissions it needs, at the point of first use, with a plain-language explanation. |
| REQ-PRV-002 | M | The system shall not transmit audio or transcripts off-device except through user-enabled sync or export. |
| REQ-PRV-003 | M | Before the first recording, the system shall show a one-time notice that recording laws vary and that participant consent may be required. |
| REQ-PRV-004 | S | The system shall offer a one-click "copy consent message" (for meeting chat) when a call recording starts. |
| REQ-PRV-005 | S | Data at rest shall use iOS/macOS Data Protection (complete until first unlock as minimum). |
| REQ-PRV-006 | S | The system shall support an app lock (Touch ID / Face ID). |
| REQ-PRV-007 | C | The system shall support a retention policy (auto-delete audio after N days, keep transcript). |

## 5. Non-functional requirements

| ID | Category | Requirement |
| --- | --- | --- |
| NFR-01 | Performance | While recording, CPU usage shall stay below 10% of one core on an M1 (capture only, live transcript off) and below 35% with live transcript on. |
| NFR-02 | Performance | Final transcription of a 60-minute recording shall complete in under 6 minutes on an M1 MacBook and under 20 minutes on an iPhone 15. |
| NFR-03 | Accuracy | Word error rate shall be at most 10% on clean English call audio (benchmark set defined in tasks T-QA-01). |
| NFR-04 | Reliability | Zero recordings lost across 100 forced-crash test runs (max 10 s tail loss). |
| NFR-05 | Storage | Audio shall be stored as AAC 64 kbps mono per track (about 30 MB/hour/track) with an optional lossless setting. |
| NFR-06 | Battery | A 60-minute in-person recording on iPhone with live transcript off shall consume under 8% battery on an iPhone 15. |
| NFR-07 | Compatibility | macOS 14.4+ (Apple Silicon and Intel), iOS 17+. Best engine path on macOS 26 / iOS 26. |
| NFR-08 | Accessibility | Full VoiceOver support, Dynamic Type, keyboard navigation on macOS. |
| NFR-09 | Distribution | macOS via notarised direct download (DMG) and optionally Mac App Store; iOS via App Store / TestFlight. |
| NFR-10 | Maintainability | Shared business logic in one Swift package with at least 80% unit test coverage. |

## 6. Platform constraints and feasibility findings

| ID | Constraint | Impact | Mitigation |
| --- | --- | --- | --- |
| C-1 | macOS: system audio capture requires Screen & System Audio Recording permission (ScreenCaptureKit) or the Core Audio process tap API (macOS 14.4+) with Audio Capture permission. | Permission prompt on first use; macOS 15+ shows periodic re-confirmation for ScreenCaptureKit. | Prefer Core Audio process taps (audio-only, no screen permission, per-app scoping). ScreenCaptureKit as fallback. |
| C-2 | iOS: third-party apps cannot capture audio of another app's VoIP call (Teams/Zoom/Meet) or of cellular calls. | SC-3 cannot be fully achieved by any App Store app. | (a) iOS 18.1+ native Phone call recording, then import into Recordme (REQ-CAP-010). (b) Put the call on speaker and record via mic (captures both sides, lower quality). (c) Join the call on the Mac and let the Mac record. |
| C-3 | iOS ReplayKit broadcast can capture app audio, but many VoIP apps use voice-processing audio that is excluded or muted, and the extension has a 50 MB memory cap. | Unreliable, app-dependent. | Ship as "experimental" (REQ-CAP-011, Could) after a technical spike. |
| C-4 | iOS background recording requires the `audio` background mode and an active audio session. Interruptions (phone call, Siri) pause the session. | Gaps possible. | Handle interruptions, auto-resume, mark gaps in the transcript. |
| C-5 | macOS App Store sandbox restricts some Core Audio tap usage and global shortcuts. | Feature parity risk on MAS build. | Primary channel is notarised direct download; MAS build is a later variant. |
| C-6 | Recording laws (one-party vs all-party consent, GDPR) vary by jurisdiction. | Legal exposure for the user. | REQ-PRV-003/004; visible indicators; no covert mode. |

## 7. Benchmark against reference products

| Capability | Plaud Note | Meetily | **Recordme** |
| --- | --- | --- | --- |
| Capture method | Hardware device | Desktop system audio + mic | Desktop system audio + mic, iPhone mic |
| Bot joins meeting | No | No | No |
| Transcription | Cloud | Local (Whisper) | Local (SpeechAnalyzer / WhisperKit) |
| AI summaries | Yes | Yes (local LLM) | **No, by design** |
| iPhone app | Companion | No | Full recorder + library |
| Speaker labels | Cloud diarisation | Basic | Track based Me/Remote + local diarisation |

## 8. Assumptions

* A1. Single user, personal use; no team workspace or admin console in v1.
* A2. Mac is Apple Silicon for target performance; Intel supported best effort.
* A3. English first; other languages supported by the engine are available but not benchmarked in v1.
* A4. The user has an Apple Developer account for signing and distribution.
* A5. iCloud (CloudKit private database) is acceptable as the sync backend.

## 9. Open questions for alignment

| # | Question | Default if no answer |
| --- | --- | --- |
| Q1 | Is iPhone call recording via import (C-2 mitigation a) plus speakerphone acceptable for v1? | Yes |
| Q2 | Distribution: direct-download Mac app, App Store, or both? | Direct download first |
| Q3 | Languages beyond English needed at launch (for example Hindi, Hinglish code-switching)? | English + auto-detect |
| Q4 | Is iCloud sync required at MVP, or can v1 be Mac-only and iPhone-only with export? | Sync in v1.0, not MVP |
| Q5 | Should live transcript be in MVP or only post-call transcript? | Post-call in MVP, live in v1.0 |
| Q6 | Is optional AWS S3 backup (REQ-SYN-003) of interest for enterprise or personal archiving? | Could, post v1 |
| Q7 | Minimum OS: can we require macOS 14.4 / iOS 17? | Yes |

## 10. Traceability

Every requirement ID is referenced in `specs/03-tasks.md`. Tests are named `test_<REQ-ID>_<behaviour>` where practical.
