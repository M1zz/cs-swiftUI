// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

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

            // TODO: Circle을 progress 비율만큼 trim하고, stroke + 회전 애니메이션 적용
        }
    }
}

#Preview {
    RingProgressView(progress: 0.6, ringColor: .orange, lineWidth: 10)
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
}
