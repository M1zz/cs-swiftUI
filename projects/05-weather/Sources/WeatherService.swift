// ============================================================
// 📖 읽기 순서: 2번째 / 전체 5개
// 파일 역할: 네트워크 레이어 (async/await, URLComponents)
// ============================================================
import Foundation

// MARK: - 날씨 API 서비스
// Open-Meteo: 무료, API 키 불필요
@Observable
class WeatherService {

    var weatherData: [UUID: WeatherResponse] = [:]  // 도시별 캐시
    // 💡 TODO: 마지막 업데이트 시각 저장 → var lastUpdated: [UUID: Date] = [:]
    //    추가 위치: 바로 아래 weatherData 프로퍼티 아래
    var isLoading = false
    var errorMessage: String?

    private let baseURL = "https://api.open-meteo.com/v1/forecast"

    func fetch(city: City) async {
        isLoading = true
        errorMessage = nil

        let params = [
            "latitude":  String(city.latitude),
            "longitude": String(city.longitude),
            "current":   "temperature_2m,weathercode,windspeed_10m",
            "hourly":    "temperature_2m,weathercode",
            "daily":     "weathercode,temperature_2m_max,temperature_2m_min",
            "timezone":  "Asia/Seoul",
            "forecast_days": "7",
        ]

        var components = URLComponents(string: baseURL)!
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        // 💡 TODO: 대기질 API 추가 (hourly에 "pm10,pm2_5" 추가)
        //    추가 위치: 바로 아래 queryItems 배열 아래

        guard let url = components.url else {
            errorMessage = "잘못된 URL"
            isLoading = false
            return
        }

        // 💡 TODO: 오프라인 캐시 (Cache-Control 헤더 활용 or URLCache)
        //    추가 위치: 바로 아래 fetch 메서드 안 URLSession 호출 위
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
            await MainActor.run {
                weatherData[city.id] = response
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "데이터를 불러올 수 없습니다: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
