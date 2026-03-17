// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import SwiftData
import Foundation

// MARK: - 거래 모델 (SwiftData @Model)
@Model
class Transaction {
    var id: UUID
    var title: String
    var amount: Double        // 양수 = 수입, 음수 = 지출
    var category: String
    var date: Date
    var note: String

    init(
        title: String,
        amount: Double,
        category: String,
        date: Date = Date(),
        note: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }

    var isIncome: Bool {
        // TODO: amount > 0이면 true
        return false
    }

    var absAmount: Double {
        // TODO: amount의 절댓값
        return 0
    }
}

// MARK: - 카테고리 정의
struct BudgetCategory {
    let name: String
    let emoji: String
    let isIncome: Bool

    static let expenses: [BudgetCategory] = [
        BudgetCategory(name: "식비",     emoji: "🍔", isIncome: false),
        BudgetCategory(name: "교통",     emoji: "🚇", isIncome: false),
        BudgetCategory(name: "쇼핑",     emoji: "🛍", isIncome: false),
        BudgetCategory(name: "의료",     emoji: "💊", isIncome: false),
        BudgetCategory(name: "여가",     emoji: "🎮", isIncome: false),
        BudgetCategory(name: "주거",     emoji: "🏠", isIncome: false),
        BudgetCategory(name: "통신",     emoji: "📱", isIncome: false),
        BudgetCategory(name: "기타",     emoji: "📦", isIncome: false),
    ]

    static let incomes: [BudgetCategory] = [
        BudgetCategory(name: "월급",     emoji: "💰", isIncome: true),
        BudgetCategory(name: "부업",     emoji: "💼", isIncome: true),
        BudgetCategory(name: "투자",     emoji: "📈", isIncome: true),
        BudgetCategory(name: "기타",     emoji: "🎁", isIncome: true),
    ]

    static var all: [BudgetCategory] { incomes + expenses }

    static func emoji(for category: String) -> String {
        all.first { $0.name == category }?.emoji ?? "💳"
    }
}
