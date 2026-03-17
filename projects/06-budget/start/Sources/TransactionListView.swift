// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
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
        // TODO: searchText + filterIncome으로 transactions 필터링
        return transactions
    }

    // 날짜별 그룹핑
    private var grouped: [(String, [Transaction])] {
        // TODO: filtered를 날짜 문자열 기준으로 그룹핑, 내림차순 정렬
        return []
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
        // TODO: Date를 "yyyy년 M월 d일 (E)" 형식 문자열로 변환
        return ""
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
