// ============================================================
// 📖 읽기 순서: 3번째 / 전체 6개
// 파일 역할: 차트 대시보드 (@Query, Swift Charts)
// ============================================================
import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query private var transactions: [Transaction]
    // 💡 TODO: #Predicate로 이번 달만 필터링 → @Query(filter: #Predicate { ... })
    //    추가 위치: 바로 아래 @Query 아래
    @State private var selectedMonth: Date = Date()

    // 선택 월의 거래만 필터
    private var monthlyTransactions: [Transaction] {
        let cal = Calendar.current
        return transactions.filter {
            cal.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }

    private var totalIncome: Double {
        monthlyTransactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }

    private var totalExpense: Double {
        monthlyTransactions.filter { !$0.isIncome }.reduce(0) { $0 + abs($1.amount) }
    }

    private var balance: Double { totalIncome - totalExpense }

    // 카테고리별 지출 집계
    private var expenseByCategory: [(String, Double)] {
        let expenses = monthlyTransactions.filter { !$0.isIncome }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        return grouped
            .map { ($0.key, $0.value.reduce(0) { $0 + abs($1.amount) }) }
            .sorted { $0.1 > $1.1 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 월 선택
                    monthPicker

                    // 잔액 카드
                    balanceCard

                    // 수입/지출 요약
                    summaryRow

                    // 카테고리 차트
                    if !expenseByCategory.isEmpty {
                        categoryChart
                    }
                }
                .padding()
            }
            .navigationTitle("대시보드")
        }
    }

    // MARK: - 월 선택
    private var monthPicker: some View {
        HStack {
            Button {
                selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth)!
            } label: { Image(systemName: "chevron.left") }

            Text(monthString)
                .font(.headline)
                .frame(width: 100)

            Button {
                selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth)!
            } label: { Image(systemName: "chevron.right") }
        }
        .padding(.vertical, 8)
    }

    private var monthString: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월"
        return f.string(from: selectedMonth)
    }

    // MARK: - 잔액 카드
    private var balanceCard: some View {
        VStack(spacing: 6) {
            Text("이번 달 잔액")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("₩\(Int(balance).formatted())")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(balance >= 0 ? .green : .red)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - 수입/지출 요약
    private var summaryRow: some View {
        HStack(spacing: 12) {
            SummaryTile(title: "수입", amount: totalIncome, color: .green)
            SummaryTile(title: "지출", amount: totalExpense, color: .red)
        }
    }

    // MARK: - 카테고리 바 차트
    private var categoryChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("카테고리별 지출")
                .font(.headline)

            Chart(expenseByCategory, id: \.0) { name, amount in
                BarMark(
                    x: .value("금액", amount),
                    y: .value("카테고리", name)
                )
                .foregroundStyle(by: .value("카테고리", name))
                .annotation(position: .trailing) {
                    Text("₩\(Int(amount).formatted())")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: CGFloat(expenseByCategory.count) * 36 + 20)
            // 💡 TODO: 월별 추이 꺾은선 차트 (LineMark으로 전월 대비 비교)
            //    추가 위치: 바로 아래 Chart 블록 아래
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// 💡 TODO: 예산 목표 대비 달성률 ProgressView
//    추가 위치: 바로 아래 SummaryTile 아래

// MARK: - 수입/지출 타일
struct SummaryTile: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: title == "수입" ? "arrow.down.circle" : "arrow.up.circle")
                .font(.caption.bold())
                .foregroundStyle(color)
            Text("₩\(Int(amount).formatted())")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
