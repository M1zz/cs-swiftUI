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
}
