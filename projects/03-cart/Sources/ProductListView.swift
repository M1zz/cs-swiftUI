// ============================================================
// 📖 읽기 순서: 3번째 / 전체 6개
// 파일 역할: 상품 목록 UI (검색, 카테고리 필터)
// ============================================================

import SwiftUI

struct ProductListView: View {
    @Environment(CartStore.self) private var store
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private var categories: [String] {
        Array(Set(Product.samples.map { $0.category })).sorted()
    }

    private var filtered: [Product] {
        Product.samples.filter { product in
            let matchSearch = searchText.isEmpty ||
                product.name.localizedCaseInsensitiveContains(searchText)
            let matchCategory = selectedCategory == nil ||
                product.category == selectedCategory
            return matchSearch && matchCategory
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // 카테고리 필터 칩
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        CategoryChip(title: "전체", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(categories, id: \.self) { cat in
                            CategoryChip(title: cat, isSelected: selectedCategory == cat) {
                                selectedCategory = selectedCategory == cat ? nil : cat
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowSeparator(.hidden)

                // 상품 목록
                ForEach(filtered) { product in
                    ProductRow(product: product, store: store)
                }
            }
            .listStyle(.plain)
            .navigationTitle("상품 목록")
            .searchable(text: $searchText, prompt: "상품 검색")
            // 💡 TODO: 가격 범위 필터 (RangeSlider)
            //    추가 위치: 바로 아래 .searchable 옆 또는 아래
        }
    }
}

// MARK: - 카테고리 칩
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 상품 행
struct ProductRow: View {
    let product: Product
    let store: CartStore

    var body: some View {
        HStack(spacing: 14) {
            Text(product.emoji).font(.largeTitle)

            VStack(alignment: .leading, spacing: 3) {
                Text(product.name).font(.subheadline.bold())
                Text("₩\(product.price.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // 💡 TODO: 상품 상세 화면 (NavigationLink → ProductDetailView)
            //    추가 위치: 바로 아래 QuantityStepper 옆 또는 아래
            // 수량 조절 (장바구니에 담겨있을 때)
            if store.quantity(of: product) > 0 {
                QuantityStepper(product: product, store: store)
            } else {
                Button {
                    store.add(product)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 수량 조절 뷰
struct QuantityStepper: View {
    let product: Product
    let store: CartStore

    var body: some View {
        HStack(spacing: 12) {
            Button { store.remove(product) } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundStyle(.orange)
            }
            Text("\(store.quantity(of: product))")
                .font(.subheadline.bold())
                .frame(minWidth: 20)
            Button { store.add(product) } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.accentColor)
            }
        }
        .buttonStyle(.plain)
    }
}
