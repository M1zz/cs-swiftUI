// ============================================================
// 📖 읽기 순서: 1번째 / 전체 5개
// 파일 역할: 메모 데이터 모델 (Codable struct, preview 프로퍼티)
// ============================================================
import Foundation

// MARK: - 메모 모델
// Codable: JSON으로 변환 가능 → UserDefaults 저장 가능
// Identifiable: ForEach, List에서 사용 가능
struct Memo: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var updatedAt: Date = Date()

    // 목록에 표시할 미리보기 (첫 번째 줄)
    var preview: String {
        let firstLine = body.components(separatedBy: "\n").first ?? ""
        return firstLine.isEmpty ? "내용 없음" : firstLine
    }

    // 💡 TODO: 태그 배열 추가 → var tags: [String] = []
    //    추가 위치: 바로 아래 updatedAt 프로퍼티 옆 또는 아래

    // 💡 TODO: 즐겨찾기 → var isPinned: Bool = false (List 최상단 고정)
    //    추가 위치: 바로 아래 tags 프로퍼티 옆 또는 아래
}
