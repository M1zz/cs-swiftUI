// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

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
                Text(timeString(elapsedTime))
                    .font(.system(size: 72, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)

                // ── 현재 랩 시간 ──
                if !laps.isEmpty {
                    Text("현재 랩: \(timeString(currentLapTime))")
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
                        lapOrReset()
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
                                    Text(timeString(laps[i]))
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
            // TODO: 0.01초마다 elapsed 증가
        }
    }

    // MARK: - 랩 / 리셋
    private func lapOrReset() {
        // TODO: isRunning이면 랩 기록, 아니면 초기화
    }

    // MARK: - 최단/최장 랩 색상
    private func lapColor(index: Int) -> Color {
        // TODO: 최소 랩은 green, 최대 랩은 red, 나머지는 primary
        return .primary
    }

    // MARK: - 시간 포맷 (mm:ss.xx)
    private func timeString(_ time: Double) -> String {
        // TODO: elapsed를 mm:ss.xx 포맷으로
        return "00:00.00"
    }
}
