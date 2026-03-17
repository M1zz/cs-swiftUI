// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
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
        // TODO: State의 밑줄 초기화 패턴으로 memo의 값을 초기값으로 설정
        _title = State(initialValue: "")
        _body  = State(initialValue: "")
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
        }
        .navigationTitle("메모 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    save()
                }
                .bold()
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("삭제", role: .destructive) {
                    deleteAndDismiss()
                }
                .foregroundStyle(.red)
            }
        }
    }

    private func save() {
        // TODO: store.update(memo) 호출 후 dismiss()
    }

    private func deleteAndDismiss() {
        // TODO: store.delete(memo) 호출 후 dismiss()
    }
}
