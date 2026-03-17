// ============================================================
// 📖 읽기 순서: 5번째 / 전체 6개
// 파일 역할: TabView 구성
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
