// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

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
