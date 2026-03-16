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
