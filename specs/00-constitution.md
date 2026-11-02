# Recordme Constitution

These principles govern every requirement, design decision and pull request. A change that violates one needs an ADR that explicitly amends this file.

1. **Raw transcript only.** The product outputs what was said, as said. No summaries, no action items, no "cleaned up" rewrites, no LLM post-processing. Punctuation and casing from the speech engine are allowed; content changes are not.
2. **Local-first and private by default.** Capture, storage and transcription run on the user's device. No network calls are needed for the core flow. Cloud sync is opt-in and end-to-end protected.
3. **Never lose a recording.** Audio is written to disk incrementally and crash-safely. Transcription can always be re-run from the stored audio.
4. **Consent is a feature.** The app makes it easy to inform participants and never records covertly by design (visible indicators, optional consent message).
5. **Native and lightweight.** Swift + SwiftUI, Apple frameworks first. Low CPU while recording so calls are not degraded.
6. **Spec before code.** Every feature traces to a requirement ID; every requirement has testable acceptance criteria.
7. **Honest platform limits.** Where Apple's sandbox prevents a capability (notably capturing other apps' call audio on iPhone), we document it and provide the best legitimate alternative rather than fragile hacks.
