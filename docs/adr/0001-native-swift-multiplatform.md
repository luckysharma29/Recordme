# ADR 0001: Native Swift + SwiftUI multiplatform

Status: Accepted

## Context
The app must capture system audio on macOS (Core Audio, ScreenCaptureKit), run background audio and Live Activities on iOS, and use Apple's on-device speech stack. Cross-platform options (Tauri, Electron, Flutter, React Native) would need native plugins for all of these anyway.

## Decision
Build with Swift 6 and SwiftUI. Share domain, pipeline, storage and export logic in a Swift package `RecordmeCore`. Platform adapters live in each app target. XcodeGen generates the project to keep it diff-friendly.

## Consequences
* Best access to capture and speech APIs, smallest footprint, lowest CPU.
* No Windows/Android path without a rewrite of the UI layer (accepted, NG4).
* `RecordmeCore` pure-Swift parts are testable on Linux CI.
