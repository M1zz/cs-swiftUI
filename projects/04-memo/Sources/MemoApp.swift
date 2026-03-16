import SwiftUI

@main
struct MemoApp: App {
    @State private var store = MemoStore()

    var body: some Scene {
        WindowGroup {
            MemoListView()
                .environment(store)
        }
    }
}
