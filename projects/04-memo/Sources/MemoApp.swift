// ============================================================
// 📖 읽기 순서: 5번째 / 전체 5개
// 파일 역할: 앱 진입점
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
