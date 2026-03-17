// ============================================================
// 📖 읽기 순서: 4번째 / 전체 6개
// 파일 역할: 거래 내역 목록 (날짜 그룹핑, 필터, 삭제)
// ============================================================
import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Environment(\.modelContext) private var context
    @State private var showAdd = false
    @State private var searchText = ""
    @State private var filterIncome: Bool? = nil  // nil = 전체

    private var filtered: [Transaction] {
        transactions.filter { t in
            let matchSearch = searchText.isEmpty ||
                t.title.localizedCaseInsensitiveContains(searchText) ||
                t.category.localizedCaseInsensitiveContains(searchText)
            let matchType: Bool
            if let fi = filterIncome { matchType = t.isIncome == fi }
            else { matchType = true }
            return matchSearch && matchType
        }
    }

    // 날짜별 그룹핑
    private var grouped: [(String, [Transaction])] {
        let dict = Dictionary(grouping: filtered) { dateKey($0.date) }
        return dict.sorted { $0.key > $1.key }
    }
    // 💡 TODO: 월별 합계 섹션 헤더에 표시 (수입/지출 소계)
    //    추가 위치: 바로 아래 grouped 프로퍼티 아래

    var body: some View {
        NavigationStack {
            List {
                // 필터 세그먼트
                Picker("유형", selection: $filterIncome) {
                    Text("전체").tag(Bool?.none)
                    Text("수입").tag(Bool?.some(true))
                    Text("지출").tag(Bool?.some(false))
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)

                // 날짜별 섹션
                ForEach(grouped, id: \.0) { dateStr, items in
                    Section(header: Text(dateStr).font(.caption).foregroundStyle(.secondary)) {
                        ForEach(items) { t in
                            TransactionRow(transaction: t)
                        }
                        .onDelete { offsets in
                            for i in offsets { context.delete(items[i]) }
                        }
                        // 💡 TODO: Swipe action으로 수정 버튼 추가 (편집 시트)
                        //    추가 위치: 바로 아래 .onDelete 아래
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("거래 내역")
            .searchable(text: $searchText, prompt: "검색")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddTransactionView()
            }
        }
    }

    private func dateKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월 d일 (E)"
        return f.string(from: date)
    }
}

// MARK: - 거래 행
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            Text(BudgetCategory.emoji(for: transaction.category))
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title).font(.subheadline.bold())
                Text(transaction.category).font(.caption).foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(transaction.isIncome ? "+" : "-")₩\(Int(transaction.absAmount).formatted())")
                .font(.subheadline.bold())
                .foregroundStyle(transaction.isIncome ? .green : .primary)
        }
        .padding(.vertical, 2)
    }
}
