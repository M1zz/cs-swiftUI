// ============================================================
// 📖 읽기 순서: 1번째 / 전체 6개
// 파일 역할: SwiftData @Model 클래스 (BudgetCategory 포함)
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

    var isIncome: Bool { amount > 0 }
    var absAmount: Double { abs(amount) }

    // 💡 TODO: 반복 거래 → var isRecurring: Bool = false, recurringInterval: Int? = nil
    //    추가 위치: 바로 아래 absAmount 프로퍼티 아래
}

// MARK: - 카테고리 정의
// 💡 TODO: 사용자 정의 카테고리 (SwiftData @Model BudgetCategoryModel)
//    추가 위치: 바로 아래 BudgetCategory 구조체 아래
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
