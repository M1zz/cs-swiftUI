#!/bin/bash
# Clone Coding Projects — Package.swift 생성 스크립트
# 각 프로젝트 폴더에 Package.swift를 생성합니다.
# 실행: ./setup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 SwiftUI Clone Coding — Xcode Package 설정"
echo "================================================"

# ──────────────────────────────────────────────
# 01 — 계산기
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/01-calculator/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Calculator",
            path: "Sources"
        )
    ]
)
EOF
echo "✅ 01-calculator/Package.swift 생성됨"

# ──────────────────────────────────────────────
# 02 — 타이머·스톱워치
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/02-timer/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TimerApp",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "TimerApp",
            path: "Sources"
        )
    ]
)
EOF
echo "✅ 02-timer/Package.swift 생성됨"

# ──────────────────────────────────────────────
# 03 — 장바구니
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/03-cart/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ShoppingCart",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "ShoppingCart",
            path: "Sources"
        )
    ]
)
EOF
echo "✅ 03-cart/Package.swift 생성됨"

# ──────────────────────────────────────────────
# 04 — 메모장
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/04-memo/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MemoApp",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "MemoApp",
            path: "Sources"
        )
    ]
)
EOF
echo "✅ 04-memo/Package.swift 생성됨"

# ──────────────────────────────────────────────
# 05 — 날씨
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/05-weather/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WeatherApp",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .executableTarget(
            name: "WeatherApp",
            path: "Sources"
        )
    ]
)
EOF
echo "✅ 05-weather/Package.swift 생성됨"

# ──────────────────────────────────────────────
# 06 — 가계부 (SwiftData + Charts)
# ──────────────────────────────────────────────
cat > "$SCRIPT_DIR/06-budget/Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BudgetApp",
    platforms: [.iOS(.v17)],
    targets: [
        .executableTarget(
            name: "BudgetApp",
            path: "Sources",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
EOF
echo "✅ 06-budget/Package.swift 생성됨"

echo ""
echo "================================================"
echo "✅ 완료! Xcode에서 열기:"
echo "   File → Open → [프로젝트 폴더]/Package.swift"
echo ""
echo "⚠️  06-budget는 SwiftData를 사용하므로"
echo "   Xcode 15 + iOS 17 시뮬레이터 필요"
echo "================================================"
