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
