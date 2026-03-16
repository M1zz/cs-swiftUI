import SwiftUI

struct MemoListView: View {
    @Environment(MemoStore.self) private var store
    @State private var searchText = ""
    @State private var showingNew = false
    @State private var sortByDate = true

    private var displayed: [Memo] {
        let result = store.search(searchText)
        return sortByDate
            ? result.sorted { $0.updatedAt > $1.updatedAt }
            : result.sorted { $0.title < $1.title }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(displayed) { memo in
                    NavigationLink(destination: MemoEditView(memo: memo)) {
                        MemoRowView(memo: memo)
                    }
                }
                .onDelete { store.delete(at: $0) }
            }
            .listStyle(.plain)
            .navigationTitle("메모")
            .searchable(text: $searchText, prompt: "검색")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("날짜순") { sortByDate = true }
                        Button("이름순") { sortByDate = false }
                    } label: {
                        Label("정렬", systemImage: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.add()
                        showingNew = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .overlay {
                if displayed.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "메모 없음" : "검색 결과 없음",
                        systemImage: searchText.isEmpty ? "note.text" : "magnifyingglass",
                        description: Text(searchText.isEmpty ? "오른쪽 상단 버튼을 눌러 새 메모를 작성하세요." : "다른 검색어를 입력해보세요.")
                    )
                }
            }
        }
        // 새 메모 → 첫 번째(가장 최신) 메모 편집 화면으로 이동
        .sheet(isPresented: $showingNew) {
            if let first = store.memos.first {
                NavigationStack {
                    MemoEditView(memo: first)
                }
            }
        }
    }
}

// MARK: - 메모 목록 행
struct MemoRowView: View {
    let memo: Memo

    private var dateString: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        let cal = Calendar.current
        if cal.isDateInToday(memo.updatedAt) {
            f.dateFormat = "a h:mm"
        } else {
            f.dateFormat = "M월 d일"
        }
        return f.string(from: memo.updatedAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(memo.title)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Spacer()
                Text(dateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(memo.preview)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
