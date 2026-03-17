// ============================================================
// 📖 읽기 순서: 6번째 / 전체 6개
// 파일 역할: 앱 진입점 (.modelContainer)
// ============================================================
import SwiftUI
import SwiftData

@main
struct BudgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Transaction.self)
    }
}
