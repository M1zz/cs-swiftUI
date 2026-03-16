import SwiftUI

@main
struct CartApp: App {
    @State private var store = CartStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
