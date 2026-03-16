import Foundation

// MARK: - 장바구니 스토어 (전체 앱에서 공유하는 상태)
@Observable
class CartStore {

    var items: [CartItem] = []

    // 총 금액
    var totalPrice: Int {
        items.reduce(0) { $0 + $1.subtotal }
    }

    // 총 수량
    var totalCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    // 특정 상품이 장바구니에 있는지
    func quantity(of product: Product) -> Int {
        items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }

    // 상품 추가 (이미 있으면 수량 +1)
    func add(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    // 수량 감소 (0이 되면 제거)
    func remove(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    // 항목 완전 삭제
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    // 장바구니 비우기
    func clear() {
        items.removeAll()
    }
}
