// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("대시보드", systemImage: "chart.bar") }

            TransactionListView()
                .tabItem { Label("내역", systemImage: "list.bullet") }
        }
    }
}
