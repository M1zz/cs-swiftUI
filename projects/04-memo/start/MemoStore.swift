// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================
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
        // TODO: 새 Memo 생성해서 items 앞에 insert
    }

    func update(_ memo: Memo) {
        // TODO: items에서 id 찾아 title/body 업데이트
    }

    func delete(at offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
    }

    func delete(_ memo: Memo) {
        // TODO: items에서 해당 id 제거
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
        // TODO: items를 JSONEncoder로 인코딩 → UserDefaults에 저장
    }

    private func load() {
        // TODO: UserDefaults에서 Data 로드 → JSONDecoder로 [Memo] 복원
    }
}
