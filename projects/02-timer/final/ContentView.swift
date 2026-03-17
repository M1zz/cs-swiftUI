// ============================================================
// 📖 읽기 순서: 4번째 / 전체 5개
// 파일 역할: TabView 구성
// ============================================================

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }
            StopwatchView()
                .tabItem {
                    Label("스톱워치", systemImage: "stopwatch")
                }
        }
        .tint(.orange)
    }
}
