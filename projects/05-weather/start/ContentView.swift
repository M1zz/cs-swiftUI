// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import SwiftUI

struct ContentView: View {
    @Environment(WeatherService.self) private var service
    @State private var cities: [City] = City.defaults
    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(cities.enumerated()), id: \.offset) { index, city in
                WeatherView(city: city)
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
        .task {
            for city in cities {
                await service.fetch(city: city)
            }
        }
    }
}
