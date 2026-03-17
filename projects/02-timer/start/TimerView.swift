// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

import SwiftUI

struct TimerView: View {

    // MARK: - 상태
    @State private var totalSeconds: Int = 60       // 설정한 총 시간 (초)
    @State private var remainingSeconds: Int = 60   // 남은 시간 (초)
    @State private var isRunning = false
    @State private var showPicker = false

    // Timer.publish: 매 1초마다 이벤트를 발행하는 Publisher
    // autoconnect(): 구독 즉시 타이머 시작
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - 계산 프로퍼티
    private var progress: Double {
        totalSeconds == 0 ? 0 : Double(remainingSeconds) / Double(totalSeconds)
    }

    private var displayTime: String {
        // TODO: remainingSeconds를 mm:ss 포맷 문자열로 변환
        return "00:00"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                Text("타이머")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                // ── 원형 프로그레스 ──
                ZStack {
                    RingProgressView(
                        progress: progress,
                        ringColor: .orange,
                        lineWidth: 12
                    )

                    // 남은 시간 텍스트
                    Text(displayTime)
                        .font(.system(size: 64, weight: .thin, design: .monospaced))
                        .foregroundStyle(.white)
                        .onTapGesture {
                            if !isRunning { showPicker = true }
                        }
                }
                .frame(width: 260, height: 260)

                // ── 컨트롤 버튼 ──
                HStack(spacing: 24) {
                    // 취소 버튼
                    CircleButton(title: "취소", color: .gray.opacity(0.3)) {
                        cancel()
                    }

                    // 시작 / 일시정지 버튼
                    CircleButton(
                        title: isRunning ? "일시정지" : "시작",
                        color: isRunning ? .orange.opacity(0.3) : .orange
                    ) {
                        startOrPause()
                    }
                }
            }
        }
        // Timer 이벤트 수신
        .onReceive(timer) { _ in
            // TODO: isRunning 체크 → remainingSeconds 감소 → 0이 되면 타이머 종료 처리
        }
        // 시간 설정 피커
        .sheet(isPresented: $showPicker) {
            TimePickerSheet(seconds: $totalSeconds) {
                remainingSeconds = totalSeconds
                showPicker = false
            }
        }
    }

    private func startOrPause() {
        // TODO: isRunning 토글, totalSeconds 초기화 처리
    }

    private func cancel() {
        // TODO: remainingSeconds = totalSeconds, isRunning = false
    }
}

// MARK: - 원형 컨트롤 버튼
struct CircleButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.footnote.bold())
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(color)
                .clipShape(Circle())
        }
    }
}

// MARK: - 시간 설정 피커 Sheet
struct TimePickerSheet: View {
    @Binding var seconds: Int
    let onDone: () -> Void

    @State private var minutes: Int = 1
    @State private var secs: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("시간 설정")
                .font(.title2.bold())
                .padding(.top, 24)

            HStack {
                Picker("분", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { Text("\($0) 분") }
                }
                .pickerStyle(.wheel)

                Picker("초", selection: $secs) {
                    ForEach(0..<60, id: \.self) { Text("\($0) 초") }
                }
                .pickerStyle(.wheel)
            }

            Button("완료") {
                seconds = minutes * 60 + secs
                onDone()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .padding(.bottom, 24)
        }
        .presentationDetents([.medium])
    }
}
