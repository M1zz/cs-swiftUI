// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import Foundation

// MARK: - 날씨 API 서비스
// Open-Meteo: 무료, API 키 불필요
@Observable
class WeatherService {

    var weatherData: [UUID: WeatherResponse] = [:]  // 도시별 캐시
    var isLoading = false
    var errorMessage: String?

    private let baseURL = "https://api.open-meteo.com/v1/forecast"

    func fetch(city: City) async {
        // TODO: 1. URLComponents로 open-meteo.com URL 구성
        // TODO: 2. try await URLSession.shared.data(from: url)
        // TODO: 3. JSONDecoder().decode(WeatherResponse.self, from: data)
        // TODO: 4. MainActor.run { weatherData[city.id] = response }
    }
}
