# ADR 0002: macOS system audio capture

Status: Accepted

## Context
Options: (a) virtual audio driver (BlackHole/Loopback style), (b) ScreenCaptureKit audio, (c) Core Audio process taps (`AudioHardwareCreateProcessTap`, macOS 14.4+).

## Decision
Use **Core Audio process taps** as primary: audio-only permission, per-process scoping (Teams, Zoom, browser), no driver install, no screen-recording prompt. Use **ScreenCaptureKit** as fallback for older OS or tap failure. Reject virtual drivers (install friction, kernel/driver extension, user must re-route output).

## Consequences
* Minimum OS for primary path is macOS 14.4.
* Requires `NSAudioCaptureUsageDescription`; direct distribution recommended (C-5).
* Mic and system audio are separate tracks, giving reliable Me/Remote attribution.
