// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var amountText = ""
    @State private var isIncome = false
    @State private var selectedCategory = "식비"
    @State private var date = Date()
    @State private var note = ""

    private var categories: [BudgetCategory] {
        isIncome ? BudgetCategory.incomes : BudgetCategory.expenses
    }

    private var amount: Double {
        // TODO: amountText에서 쉼표 제거 후 Double 변환
        return 0
    }

    var body: some View {
        NavigationStack {
            Form {
                // 수입/지출 토글
                Section {
                    Picker("유형", selection: $isIncome) {
                        Text("지출").tag(false)
                        Text("수입").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isIncome) {
                        // 유형 바꾸면 카테고리 초기화
                        selectedCategory = categories.first?.name ?? ""
                    }
                }

                // 기본 정보
                Section("내용") {
                    TextField("제목", text: $title)
                    HStack {
                        Text("₩")
                        TextField("금액", text: $amountText)
                            .keyboardType(.numberPad)
                    }
                    DatePicker("날짜", selection: $date, displayedComponents: .date)
                }

                // 카테고리 선택
                Section("카테고리") {
                    Picker("카테고리", selection: $selectedCategory) {
                        ForEach(categories, id: \.name) { cat in
                            Label(cat.name, title: Text(cat.emoji)).tag(cat.name)
                        }
                    }
                }

                // 메모
                Section("메모 (선택)") {
                    TextEditor(text: $note)
                        .frame(height: 80)
                }
            }
            .navigationTitle("거래 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") { save() }
                        .bold()
                        .disabled(title.isEmpty || amount == 0)
                }
            }
        }
    }

    private func save() {
        // TODO: isIncome에 따라 amount 부호 결정 → Transaction 생성 → context.insert → dismiss
    }
}
