import SwiftUI

@main struct MyApp: App {
    @State private var theme = ThemeManager.shared
    @State private var store = ChatStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(theme)
                .environment(store)
        }
    }
}
