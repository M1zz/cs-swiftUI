// ============================================================
// 📖 읽기 순서: 2번째 / 전체 5개
// 파일 역할: 메모 저장소 (UserDefaults + JSONEncoder/Decoder, didSet)
// ============================================================
import Foundation

// MARK: - 메모 스토어 (UserDefaults 영속성)
@Observable
class MemoStore {

    private let key = "memos_v1"

    var memos: [Memo] = [] {
        didSet { save() }   // 변경될 때마다 자동 저장
        // 💡 TODO: iCloud 동기화 (NSUbiquitousKeyValueStore 대신 CloudKit)
        //    추가 위치: 바로 아래 didSet 블록 안 또는 save() 호출 아래
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

    // 💡 TODO: 휴지통 기능 (isDeleted 플래그로 soft delete)
    //    추가 위치: 바로 아래 delete 함수 아래

    // MARK: - 검색
    func search(_ query: String) -> [Memo] {
        guard !query.isEmpty else { return memos }
        return memos.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.body.localizedCaseInsensitiveContains(query)
        }
    }

    // MARK: - 저장 / 불러오기 (UserDefaults + Codable)
    // 💡 TODO: SwiftData로 마이그레이션 (@Model class Memo + @Query)
    //    추가 위치: 바로 아래 save 메서드 옆 또는 아래
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
