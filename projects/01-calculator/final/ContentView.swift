// ============================================================
// 📖 읽기 순서: 3번째 / 전체 4개
// 파일 역할: UI 레이아웃 (GeometryReader, 버튼 그리드)
// ============================================================

import SwiftUI

struct ContentView: View {

    @State private var logic = CalculatorLogic()

    // 버튼 크기: 화면 너비에서 여백을 빼고 4등분
    private var buttonSize: CGFloat {
        (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()
                // 💡 TODO: 계산 히스토리 목록 (DisclosureGroup으로 접기/펼치기)
                //    추가 위치: 바로 아래 displayView 옆 또는 아래

                // ── 디스플레이 ──
                displayView

                // ── 버튼 그리드 ──
                buttonGrid
            }
            .padding(12)
        }
    }

    // MARK: - 디스플레이
    private var displayView: some View {
        HStack {
            Spacer()
            Text(logic.displayText)
                .font(.system(size: displayFontSize, weight: .thin))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .padding(.horizontal, 8)
        }
    }

    // 숫자가 길어지면 글자를 줄인다
    private var displayFontSize: CGFloat {
        logic.displayText.count > 9 ? 56 : 88
    }

    // MARK: - 버튼 그리드
    private var buttonGrid: some View {
        VStack(spacing: 12) {
            ForEach(buttonLayout, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        CalcButtonView(
                            button: button,
                            size: buttonSize,
                            gap: 12
                        ) {
                            logic.tap(button)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 개별 버튼 뷰
struct CalcButtonView: View {

    let button: CalcButton
    let size: CGFloat
    let gap: CGFloat
    let action: () -> Void

    private var width: CGFloat {
        button.isWide ? size * 2 + gap : size
    }

    var body: some View {
        Button(action: action) {
            Text(button.rawValue)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(button.foregroundColor)
                .frame(width: width, height: size)
                .background(button.backgroundColor)
                .clipShape(Capsule())
        }
    }
}

// 💡 TODO: 가로 모드에서 공학용 버튼 행 추가 (UIDevice.current.orientation)
//    추가 위치: 바로 아래 #Preview 옆 또는 아래
#Preview {
    ContentView()
}
