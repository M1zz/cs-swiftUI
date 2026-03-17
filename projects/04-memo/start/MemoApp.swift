// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
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
