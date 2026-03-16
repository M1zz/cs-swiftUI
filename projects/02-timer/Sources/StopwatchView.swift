import SwiftUI

struct StopwatchView: View {

    // MARK: - 상태
    @State private var elapsedTime: Double = 0      // 누적 시간 (초)
    @State private var isRunning = false
    @State private var laps: [Double] = []          // 랩 기록
    @State private var lapStartTime: Double = 0     // 이번 랩 시작 시점

    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    // MARK: - 계산 프로퍼티
    private var currentLapTime: Double {
        elapsedTime - lapStartTime
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("스톱워치")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                // ── 메인 시간 표시 ──
                Text(formatted(elapsedTime))
                    .font(.system(size: 72, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)

                // ── 현재 랩 시간 ──
                if !laps.isEmpty {
                    Text("현재 랩: \(formatted(currentLapTime))")
                        .font(.system(size: 20, design: .monospaced))
                        .foregroundStyle(.orange)
                }

                // ── 컨트롤 버튼 ──
                HStack(spacing: 24) {
                    // 랩 / 리셋
                    CircleButton(
                        title: isRunning ? "랩" : "리셋",
                        color: .gray.opacity(0.3)
                    ) {
                        if isRunning {
                            recordLap()
                        } else {
                            reset()
                        }
                    }

                    // 시작 / 정지
                    CircleButton(
                        title: isRunning ? "정지" : "시작",
                        color: isRunning ? .red : .green
                    ) {
                        isRunning.toggle()
                    }
                }

                // ── 랩 목록 ──
                if !laps.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(laps.indices.reversed(), id: \.self) { i in
                                HStack {
                                    Text("랩 \(i + 1)")
                                        .foregroundStyle(.white.opacity(0.6))
                                    Spacer()
                                    Text(formatted(laps[i]))
                                        .font(.system(design: .monospaced))
                                        .foregroundStyle(lapColor(index: i))
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                Divider().background(.white.opacity(0.1))
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            elapsedTime += 0.01
        }
    }

    // MARK: - 랩 기록
    private func recordLap() {
        laps.append(currentLapTime)
        lapStartTime = elapsedTime
    }

    // MARK: - 리셋
    private func reset() {
        elapsedTime = 0
        laps = []
        lapStartTime = 0
    }

    // MARK: - 최단/최장 랩 색상
    private func lapColor(index: Int) -> Color {
        guard laps.count > 1 else { return .white }
        if laps[index] == laps.min() { return .green }
        if laps[index] == laps.max() { return .red }
        return .white
    }

    // MARK: - 시간 포맷 (mm:ss.xx)
    private func formatted(_ time: Double) -> String {
        let m = Int(time) / 60
        let s = Int(time) % 60
        let cs = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", m, s, cs)
    }
}
