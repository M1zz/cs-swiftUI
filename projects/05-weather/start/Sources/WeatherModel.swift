// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import Foundation

// MARK: - Open-Meteo API 응답 모델
// https://open-meteo.com (무료, 키 불필요)
struct WeatherResponse: Codable {
    let current: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let weathercode: Int
    let windspeed10m: Double

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case weathercode
        case windspeed10m = "windspeed_10m"
    }
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weathercode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weathercode
    }

    // 현재 시간 이후 24개 항목
    func next24: [HourlyItem] {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]

        return zip(zip(time, temperature2m), weathercode)
            .compactMap { (pair, code) -> HourlyItem? in
                let (timeStr, temp) = pair
                guard let date = formatter.date(from: timeStr + ":00"),
                      date >= now else { return nil }
                return HourlyItem(time: date, temperature: temp, weathercode: code)
            }
            .prefix(24)
            .map { $0 }
    }
}

struct HourlyItem: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let weathercode: Int
}

struct DailyWeather: Codable {
    let time: [String]
    let weathercode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time, weathercode
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
    }

    var items: [DailyItem] {
        (0..<min(time.count, 7)).map { i in
            DailyItem(
                dateString: time[i],
                weathercode: weathercode[i],
                maxTemp: temperature2mMax[i],
                minTemp: temperature2mMin[i]
            )
        }
    }
}

struct DailyItem: Identifiable {
    let id = UUID()
    let dateString: String
    let weathercode: Int
    let maxTemp: Double
    let minTemp: Double

    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let date = formatter.date(from: dateString) else { return "" }
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "E"
        return df.string(from: date)
    }
}

// MARK: - 날씨 코드 → 이모지 & 설명
extension Int {
    var weatherEmoji: String {
        // TODO: 날씨 코드 범위별 이모지 반환
        return "🌡️"
    }

    var weatherDescription: String {
        // TODO: 날씨 코드 범위별 한국어 설명 반환
        return "알 수 없음"
    }
}

// MARK: - 도시 모델
struct City: Identifiable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double

    static let defaults: [City] = [
        City(id: UUID(), name: "서울",    latitude: 37.5665, longitude: 126.9780),
        City(id: UUID(), name: "부산",    latitude: 35.1796, longitude: 129.0756),
        City(id: UUID(), name: "제주",    latitude: 33.4996, longitude: 126.5312),
    ]
}
