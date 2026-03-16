import SwiftUI

// MARK: - 원형 프로그레스 바
// progress: 0.0 ~ 1.0 (1.0 = 꽉 찬 상태)
struct RingProgressView: View {

    let progress: Double       // 남은 비율 (0.0 = 완료, 1.0 = 시작)
    let ringColor: Color
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            // 배경 원 (회색)
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: lineWidth)

            // 진행 원 (색상)
            // trim(from:to:) : 원의 특정 구간만 그린다
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    ringColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round   // 끝을 둥글게
                    )
                )
                // 기본은 3시 방향부터 시작 → -90도 회전해서 12시부터 시작
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
        }
    }
}

#Preview {
    RingProgressView(progress: 0.6, ringColor: .orange, lineWidth: 10)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}
