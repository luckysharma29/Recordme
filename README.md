# Recordme

Local-first meeting and call recorder for **macOS** and **iPhone** that produces **raw, verbatim transcripts**. No AI summaries, no action items, no rewriting. Think Plaud Note / Meetily capture quality, without the summarisation layer.

## What it does

* Records Microsoft Teams, Zoom and Google Meet calls on a Mac (system audio + your mic, kept on separate tracks).
* Records any in-person meeting on Mac or iPhone using the microphone.
* Transcribes fully on-device (Apple SpeechAnalyzer, with WhisperKit as fallback). Audio never leaves the device unless you enable sync.
* Labels speakers as **Me** / **Remote** from track separation, with optional on-device diarisation (Speaker 1, 2, ...).
* Exports TXT, Markdown, SRT, WebVTT and JSON.

## Repository layout

| Path | Purpose |
| --- | --- |
| `specs/00-constitution.md` | Non-negotiable product and engineering principles |
| `specs/01-requirements.md` | Requirements in EARS notation with acceptance criteria |
| `specs/02-design.md` | Solution architecture and component design |
| `specs/03-tasks.md` | Implementation plan traced to requirements |
| `docs/adr/` | Architecture Decision Records |
| `Sources/RecordmeCore` | Shared, platform-neutral Swift package (models, export, pipeline contracts) |
| `Apps/` | SwiftUI app targets (macOS, iOS, iOS broadcast extension) |
| `project.yml` | XcodeGen definition for the app targets |

## Getting started (on a Mac)

```bash
brew install xcodegen
xcodegen generate          # creates Recordme.xcodeproj
open Recordme.xcodeproj
swift test                 # runs RecordmeCore tests
```

Requirements: Xcode 26+, macOS 15+ for development. Runtime targets are macOS 14.4+ and iOS 17+ (SpeechAnalyzer path requires macOS 26 / iOS 26).

## Spec-driven workflow

1. Change starts in `specs/01-requirements.md` (new or amended requirement ID).
2. Design impact is captured in `specs/02-design.md` or a new ADR.
3. Work items are added to `specs/03-tasks.md` and reference requirement IDs.
4. Code and tests reference the same IDs (for example `// REQ-CAP-003`).
