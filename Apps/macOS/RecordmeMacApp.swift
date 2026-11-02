import SwiftUI
import RecordmeCore

/// Menu bar first app (design 9). Capture adapters: CoreAudioTapSource, ScreenCaptureKitSource, MicSource.
@main
struct RecordmeMacApp: App {
    @State private var isRecording = false

    var body: some Scene {
        MenuBarExtra("Recordme", systemImage: isRecording ? "record.circle.fill" : "waveform") {
            Button(isRecording ? "Stop Recording" : "Start Recording") { isRecording.toggle() }
                .keyboardShortcut("r")
            Divider()
            Button("Open Library") {}
            Button("Quit") { NSApplication.shared.terminate(nil) }
        }
        Window("Library", id: "library") {
            Text("Library (T-03-02)")
                .frame(minWidth: 800, minHeight: 500)
        }
    }
}
