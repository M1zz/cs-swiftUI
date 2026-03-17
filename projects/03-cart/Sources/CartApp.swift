// ============================================================
// 📖 읽기 순서: 6번째 / 전체 6개
// 파일 역할: 앱 진입점 (.environment 주입)
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
