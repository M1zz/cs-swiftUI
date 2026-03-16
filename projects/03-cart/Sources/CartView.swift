import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var store
    @State private var showConfirm = false

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    emptyView
                } else {
                    cartList
                }
            }
            .navigationTitle("장바구니")
            .toolbar {
                if !store.items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("비우기", role: .destructive) {
                            showConfirm = true
                        }
                    }
                }
            }
            .confirmationDialog("장바구니를 비울까요?", isPresented: $showConfirm) {
                Button("비우기", role: .destructive) { store.clear() }
            }
        }
    }

    // MARK: - 비어있는 상태
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("장바구니가 비어있습니다")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - 장바구니 목록
    private var cartList: some View {
        VStack(spacing: 0) {
            List {
                ForEach(store.items) { item in
                    CartItemRow(item: item, store: store)
                }
                .onDelete { store.delete(at: $0) }
            }
            .listStyle(.plain)

            // ── 합계 & 결제 버튼 ──
            VStack(spacing: 12) {
                Divider()
                HStack {
                    Text("총 \(store.totalCount)개")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("₩\(store.totalPrice.formatted())")
                        .font(.title3.bold())
                }
                .padding(.horizontal)

                Button {
                    // TODO: 결제 처리
                } label: {
                    Text("결제하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .background(.background)
        }
    }
}

// MARK: - 장바구니 아이템 행
struct CartItemRow: View {
    let item: CartItem
    let store: CartStore

    var body: some View {
        HStack(spacing: 14) {
            Text(item.product.emoji).font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name).font(.subheadline.bold())
                Text("₩\(item.product.price.formatted()) × \(item.quantity)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("₩\(item.subtotal.formatted())")
                    .font(.subheadline.bold())
                QuantityStepper(product: item.product, store: store)
            }
        }
        .padding(.vertical, 4)
    }
}
