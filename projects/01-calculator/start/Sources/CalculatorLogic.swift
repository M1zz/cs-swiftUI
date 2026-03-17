// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

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
        // TODO: 버튼 종류에 따라 각 메서드 호출 (switch 문)
    }

    // MARK: - 숫자 입력
    private func appendDigit(_ digit: String) {
        // TODO: shouldResetDisplay 체크 후 displayText에 숫자 추가
    }

    // MARK: - 소수점
    private func appendDot() {
        // TODO: 이미 소수점이 있으면 무시, 없으면 추가
    }

    // MARK: - 연산자 선택
    private func setOperator(_ op: Operator) {
        // TODO: 이전 연산 마저 계산 → previousValue 저장 → 플래그 설정
    }

    // MARK: - 계산 실행
    private func calculate() {
        // TODO: currentOperator switch → 사칙연산 → displayText 갱신
    }

    // MARK: - 부호 전환
    private func toggleSign() {
        // TODO: currentValue 부호 반전
    }

    // MARK: - 퍼센트
    private func applyPercent() {
        // TODO: currentValue를 100으로 나누기
    }

    // MARK: - 초기화
    private func reset() {
        // TODO: 모든 상태를 초기값으로 리셋
    }

    // MARK: - 숫자 포맷 (정수면 소수점 생략)
    private func formatted(_ value: Double) -> String {
        // TODO: 정수면 소수점 없이, 소수면 불필요한 0 제거
        return "0"
    }
}
