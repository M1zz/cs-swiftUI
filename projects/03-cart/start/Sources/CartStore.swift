// ============================================================
// 🚀 START 버전 — 핵심 로직을 직접 구현해보세요!
// 📖 Final 버전(../Sources/)을 참고하세요.
// ============================================================

import Foundation

// MARK: - 장바구니 스토어 (전체 앱에서 공유하는 상태)
@Observable
class CartStore {

    var items: [CartItem] = []

    // 총 금액
    var totalPrice: Int {
        // TODO: items를 reduce로 합산
        return 0
    }

    // 총 수량
    var totalCount: Int {
        // TODO: items를 reduce로 합산
        return 0
    }

    // 특정 상품이 장바구니에 있는지
    func quantity(of product: Product) -> Int {
        items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }

    // 상품 추가 (이미 있으면 수량 +1)
    func add(_ product: Product) {
        // TODO: 이미 있으면 수량 증가, 없으면 CartItem 새로 추가
    }

    // 수량 감소 (0이 되면 제거)
    func remove(_ product: Product) {
        // TODO: 해당 상품 수량 감소, 0이 되면 items에서 제거
    }

    // 항목 완전 삭제
    func delete(at offsets: IndexSet) {
        // TODO: offsets를 이용해 items에서 삭제
    }

    // 장바구니 비우기
    func clear() {
        // TODO: items 비우기
    }
}
