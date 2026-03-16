import SwiftUI

// MARK: - 버튼 종류 enum
// 계산기의 모든 버튼을 하나의 타입으로 표현한다.
// rawValue = 화면에 표시할 텍스트
enum CalcButton: String {
    // 숫자
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case dot = "."

    // 연산자
    case plus = "+", minus = "−", multiply = "×", divide = "÷"
    case equals = "="

    // 기능
    case ac = "AC", plusMinus = "+/−", percent = "%"

    // 버튼 배경색
    var backgroundColor: Color {
        switch self {
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        case .plus, .minus, .multiply, .divide, .equals:
            return .orange
        default:
            return Color(.darkGray)
        }
    }

    // 버튼 글자색
    var foregroundColor: Color {
        switch self {
        case .ac, .plusMinus, .percent:
            return .black
        default:
            return .white
        }
    }

    // 버튼이 두 칸을 차지하는지 (0 버튼)
    var isWide: Bool { self == .zero }
}

// MARK: - 버튼 레이아웃 (행 × 열)
// 2D 배열 그대로 LazyVGrid에 넘긴다.
let buttonLayout: [[CalcButton]] = [
    [.ac,       .plusMinus, .percent, .divide  ],
    [.seven,    .eight,     .nine,    .multiply],
    [.four,     .five,      .six,     .minus   ],
    [.one,      .two,       .three,   .plus    ],
    [.zero,                 .dot,     .equals  ],
]
