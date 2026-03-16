import Foundation

// MARK: - 상품 모델
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let emoji: String
    let category: String
}

// MARK: - 장바구니 아이템 (상품 + 수량)
struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int

    var subtotal: Int { product.price * quantity }
}

// MARK: - 샘플 상품 데이터
extension Product {
    static let samples: [Product] = [
        Product(name: "아이폰 케이스", price: 12_000, emoji: "📱", category: "액세서리"),
        Product(name: "에어팟 파우치", price: 8_000,  emoji: "🎧", category: "액세서리"),
        Product(name: "맥북 스티커 세트", price: 5_000, emoji: "💻", category: "스티커"),
        Product(name: "케이블 정리 클립", price: 3_000, emoji: "🔌", category: "액세서리"),
        Product(name: "스마트폰 거치대", price: 15_000, emoji: "🗂️", category: "데스크"),
        Product(name: "마우스 패드", price: 9_000, emoji: "🖱️", category: "데스크"),
        Product(name: "노트북 파우치", price: 22_000, emoji: "🎒", category: "가방"),
        Product(name: "미니 선풍기", price: 18_000, emoji: "🌀", category: "가전"),
    ]
}
