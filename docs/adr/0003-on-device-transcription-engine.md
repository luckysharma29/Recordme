# ADR 0003: On-device transcription engine

Status: Accepted

## Context
Requirements demand local, verbatim transcription with timestamps (REQ-TRN-001..003). Candidates: Apple `SpeechAnalyzer`/`SpeechTranscriber` (macOS/iOS 26), legacy `SFSpeechRecognizer`, WhisperKit (CoreML Whisper), whisper.cpp, cloud APIs.

## Decision
Define a `TranscriptionEngine` protocol. Ship `SpeechAnalyzerEngine` as default on OS 26+ (system-managed models, fast, long-form, energy efficient) and `WhisperKitEngine` as fallback and power-user option. No cloud engines (Constitution 2). `SFSpeechRecognizer` is not used (one-minute limits and lower quality for long-form).

## Consequences
* Two engines to test, but the protocol keeps the pipeline engine-agnostic.
* WhisperKit models (about 600 MB to 1.6 GB) are downloaded on demand and checksummed.
* Engine output is stored unmodified; no LLM layer exists anywhere in the stack.
