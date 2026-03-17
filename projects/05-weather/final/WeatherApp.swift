// ============================================================
// 📖 읽기 순서: 5번째 / 전체 5개
// 파일 역할: 앱 진입점
// ============================================================
import SwiftUI

@main
struct WeatherApp: App {
    @State private var service = WeatherService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(service)
        }
    }
}
