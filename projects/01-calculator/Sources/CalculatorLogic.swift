import Foundation

// MARK: - 연산자 타입
enum Operator {
    case add, subtract, multiply, divide
}

// MARK: - 계산기 로직 (순수 Swift — View 의존 없음)
@Observable
class CalculatorLogic {

    // 화면에 표시되는 문자열
    var displayText: String = "0"

    private var currentValue: Double = 0      // 현재 입력 중인 숫자
    private var previousValue: Double = 0     // 연산자 누르기 전 숫자
    private var currentOperator: Operator?    // 선택된 연산자
    private var shouldResetDisplay = false    // 다음 숫자 입력 시 화면 초기화 여부
    private var justPressedEquals = false     // = 직후 상태

    // MARK: - 버튼 탭 처리
    func tap(_ button: CalcButton) {
        switch button {
        case .ac:
            reset()
        case .plusMinus:
            toggleSign()
        case .percent:
            applyPercent()
        case .plus:
            setOperator(.add)
        case .minus:
            setOperator(.subtract)
        case .multiply:
            setOperator(.multiply)
        case .divide:
            setOperator(.divide)
        case .equals:
            calculate()
        case .dot:
            appendDot()
        default:
            appendDigit(button.rawValue)
        }
    }

    // MARK: - 숫자 입력
    private func appendDigit(_ digit: String) {
        if shouldResetDisplay {
            displayText = digit
            shouldResetDisplay = false
        } else {
            displayText = displayText == "0" ? digit : displayText + digit
        }
        currentValue = Double(displayText) ?? 0
        justPressedEquals = false
    }

    // MARK: - 소수점
    private func appendDot() {
        if shouldResetDisplay {
            displayText = "0."
            shouldResetDisplay = false
            return
        }
        if !displayText.contains(".") {
            displayText += "."
        }
    }

    // MARK: - 연산자 선택
    private func setOperator(_ op: Operator) {
        if !justPressedEquals {
            if currentOperator != nil && !shouldResetDisplay {
                calculate()
            }
        }
        previousValue = Double(displayText) ?? 0
        currentOperator = op
        shouldResetDisplay = true
        justPressedEquals = false
    }

    // MARK: - 계산 실행
    private func calculate() {
        guard let op = currentOperator else { return }
        let result: Double
        switch op {
        case .add:      result = previousValue + currentValue
        case .subtract: result = previousValue - currentValue
        case .multiply: result = previousValue * currentValue
        case .divide:
            // 0 나누기 방어
            result = currentValue == 0 ? 0 : previousValue / currentValue
        }
        previousValue = result
        currentValue = result
        displayText = formatted(result)
        shouldResetDisplay = true
        justPressedEquals = true
    }

    // MARK: - 부호 전환
    private func toggleSign() {
        currentValue = -currentValue
        displayText = formatted(currentValue)
    }

    // MARK: - 퍼센트
    private func applyPercent() {
        currentValue /= 100
        displayText = formatted(currentValue)
    }

    // MARK: - 초기화
    private func reset() {
        displayText = "0"
        currentValue = 0
        previousValue = 0
        currentOperator = nil
        shouldResetDisplay = false
        justPressedEquals = false
    }

    // MARK: - 숫자 포맷 (정수면 소수점 생략)
    private func formatted(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            // 최대 9자리까지 정수 표현
            let intVal = Int(value)
            return String(intVal)
        }
        // 소수는 최대 8자리
        let s = String(format: "%.8f", value)
        return s.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
    }
}
