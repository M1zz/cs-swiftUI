import Foundation

// MARK: - 메모 스토어 (UserDefaults 영속성)
@Observable
class MemoStore {

    private let key = "memos_v1"

    var memos: [Memo] = [] {
        didSet { save() }   // 변경될 때마다 자동 저장
    }

    init() { load() }

    // MARK: - CRUD

    func add(title: String = "새 메모", body: String = "") {
        let memo = Memo(title: title.isEmpty ? "새 메모" : title, body: body)
        memos.insert(memo, at: 0)   // 최신 순 — 맨 앞에 추가
    }

    func update(_ memo: Memo) {
        guard let i = memos.firstIndex(where: { $0.id == memo.id }) else { return }
        var updated = memo
        updated.updatedAt = Date()
        memos[i] = updated
    }

    func delete(at offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
    }

    func delete(_ memo: Memo) {
        memos.removeAll { $0.id == memo.id }
    }

    // MARK: - 검색
    func search(_ query: String) -> [Memo] {
        guard !query.isEmpty else { return memos }
        return memos.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.body.localizedCaseInsensitiveContains(query)
        }
    }

    // MARK: - 저장 / 불러오기 (UserDefaults + Codable)
    private func save() {
        guard let data = try? JSONEncoder().encode(memos) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([Memo].self, from: data)
        else { return }
        memos = saved
    }
}
