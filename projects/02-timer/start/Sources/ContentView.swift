// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
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
