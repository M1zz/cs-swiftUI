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
