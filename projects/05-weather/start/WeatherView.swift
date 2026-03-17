// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import SwiftUI

struct WeatherView: View {
    @Environment(WeatherService.self) private var service
    let city: City

    private var weather: WeatherResponse? { service.weatherData[city.id] }

    // 날씨 코드에 따른 배경 그라디언트
    private var gradient: LinearGradient {
        let code = weather?.current.weathercode ?? 0
        let colors: [Color]
        // TODO: weathercode에 따라 다른 그라디언트 색상 배열 반환
        colors = [.blue, .indigo]
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        ZStack {
            gradient.ignoresSafeArea()

            if service.isLoading && weather == nil {
                ProgressView().tint(.white)
            } else if let w = weather {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        mainHeader(w)
                        hourlySection(w)
                        dailySection(w)
                        extraInfo(w)
                    }
                    .padding(.bottom, 40)
                }
            } else if let err = service.errorMessage {
                Text(err).foregroundStyle(.white).padding()
            }
        }
        .task { await service.fetch(city: city) }
    }

    // MARK: - 메인 헤더 (도시명, 온도, 날씨)
    @ViewBuilder
    private func mainHeader(_ w: WeatherResponse) -> some View {
        VStack(spacing: 8) {
            Text(city.name)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("\(Int(w.current.temperature2m))°")
                .font(.system(size: 90, weight: .thin))
                .foregroundStyle(.white)

            Text(w.current.weathercode.weatherDescription)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))

            if let today = w.daily.items.first {
                Text("최고 \(Int(today.maxTemp))° 최저 \(Int(today.minTemp))°")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.top, 60)
        .padding(.bottom, 32)
    }

    // MARK: - 시간별 예보
    @ViewBuilder
    private func hourlySection(_ w: WeatherResponse) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("시간별 예보")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(w.hourly.next24) { item in
                        HourlyItemView(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        .glassCard()
    }

    // MARK: - 주간 예보
    @ViewBuilder
    private func dailySection(_ w: WeatherResponse) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("7일 예보")
            VStack(spacing: 0) {
                ForEach(w.daily.items) { day in
                    DailyRowView(day: day)
                    if day.id != w.daily.items.last?.id {
                        Divider().background(.white.opacity(0.2))
                    }
                }
            }
        }
        .glassCard()
    }

    // MARK: - 추가 정보 (풍속)
    @ViewBuilder
    private func extraInfo(_ w: WeatherResponse) -> some View {
        HStack(spacing: 12) {
            InfoTile(title: "바람", value: "\(Int(w.current.windspeed10m)) km/h", icon: "wind")
            InfoTile(title: "날씨", value: w.current.weathercode.weatherEmoji, icon: "cloud")
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.bold())
            .foregroundStyle(.white.opacity(0.6))
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }
}

// MARK: - 시간별 아이템
struct HourlyItemView: View {
    let item: HourlyItem

    private var hourString: String {
        let f = DateFormatter()
        f.dateFormat = "ha"
        f.locale = Locale(identifier: "ko_KR")
        return f.string(from: item.time)
    }

    var body: some View {
        VStack(spacing: 6) {
            Text(hourString).font(.caption).foregroundStyle(.white.opacity(0.7))
            Text(item.weathercode.weatherEmoji).font(.title3)
            Text("\(Int(item.temperature))°").font(.subheadline.bold()).foregroundStyle(.white)
        }
        .padding(.vertical, 10)
    }
}

// MARK: - 일별 행
struct DailyRowView: View {
    let day: DailyItem

    var body: some View {
        HStack {
            Text(day.dayName).font(.subheadline).foregroundStyle(.white).frame(width: 36)
            Text(day.weathercode.weatherEmoji).font(.title3)
            Spacer()
            Text("\(Int(day.minTemp))°")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 36, alignment: .trailing)
            // 온도 범위 바
            GeometryReader { geo in
                Capsule()
                    .fill(.white.opacity(0.2))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(LinearGradient(colors: [.blue, .orange], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * 0.6)
                    }
            }
            .frame(height: 4)
            Text("\(Int(day.maxTemp))°")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .frame(width: 36)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

// MARK: - 정보 타일
struct InfoTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.6))
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 유리 카드 스타일 ViewModifier
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.top, 12)
    }
}

extension View {
    func glassCard() -> some View { modifier(GlassCard()) }
}

// MARK: - Hex 색상
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
