// ============================================================
// 📖 읽기 순서: 5번째 / 전체 6개
// 파일 역할: TabView 구성
// ============================================================

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProductListView()
                .tabItem { Label("상품", systemImage: "bag") }

            CartView()
                .tabItem { Label("장바구니", systemImage: "cart") }
        }
    }
}
