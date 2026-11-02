import SwiftUI
import RecordmeCore

@main
struct RecordmeiOSApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Text("Record (T-04-01)").tabItem { Label("Record", systemImage: "record.circle") }
                Text("Library (T-04-04)").tabItem { Label("Library", systemImage: "list.bullet") }
                Text("Settings").tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }
}
