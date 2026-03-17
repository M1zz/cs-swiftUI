// ============================================================
// 📖 읽기 순서: 4번째 / 전체 5개
// 파일 역할: 메모 편집 UI (State 초기화 패턴, 저장/삭제)
// ============================================================
import SwiftUI

struct MemoEditView: View {
    @Environment(MemoStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    // 로컬 편집용 복사본 (@State) — 저장 버튼을 눌러야 실제로 반영
    @State private var title: String
    @State private var body: String

    private let originalMemo: Memo

    init(memo: Memo) {
        self.originalMemo = memo
        _title = State(initialValue: memo.title)
        _body  = State(initialValue: memo.body)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 제목 입력
            TextField("제목", text: $title)
                .font(.title2.bold())
                .padding(.horizontal)
                .padding(.top, 12)

            Divider().padding(.vertical, 8)

            // 본문 입력
            TextEditor(text: $body)
                .font(.body)
                .padding(.horizontal, 12)
            // 💡 TODO: 마크다운 프리뷰 토글 (Text(LocalizedStringKey(body)))
            //    추가 위치: 바로 아래 TextEditor 아래
        }
        .navigationTitle("메모 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    var updated = originalMemo
                    updated.title = title.isEmpty ? "새 메모" : title
                    updated.body  = body
                    // 💡 TODO: 최근 편집 날짜 자동 업데이트 (memo.updatedAt = Date())
                    //    추가 위치: 바로 아래 store.update(updated) 옆 또는 아래
                    store.update(updated)
                    dismiss()
                }
                .bold()
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("삭제", role: .destructive) {
                    store.delete(originalMemo)
                    dismiss()
                }
                .foregroundStyle(.red)
            }
        }
    }
}
