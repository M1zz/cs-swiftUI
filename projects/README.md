# Clone Coding Projects — Xcode 설정 가이드

각 프로젝트를 Xcode에서 열려면 아래 방법 중 하나를 선택하세요.

---

## 방법 A — setup.sh 스크립트 (권장)

터미널에서 실행:

```bash
cd projects
chmod +x setup.sh
./setup.sh
```

각 프로젝트 폴더에 `Package.swift`가 생성됩니다.
Xcode에서 `Package.swift`를 열면 바로 빌드 가능합니다.

---

## 방법 B — Xcode에서 직접 프로젝트 생성

1. Xcode → File → New → Project
2. **iOS → App** 선택
3. 아래 설정:
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum Deployment: **iOS 17.0**
4. 프로젝트 생성 후 기본 `ContentView.swift` **삭제** (Move to Trash)
5. `Sources/` 폴더 안의 모든 `.swift` 파일을 프로젝트에 드래그 앤 드롭

---

## 프로젝트 목록

| 폴더 | 앱 이름 | 주요 기술 |
|------|---------|-----------|
| 01-calculator | 계산기 | @Observable, GeometryReader |
| 02-timer | 타이머·스톱워치 | Timer.publish, Path.trim |
| 03-cart | 장바구니 | @Observable + .environment |
| 04-memo | 메모장 | UserDefaults, JSONEncoder |
| 05-weather | 날씨 | async/await, URLSession |
| 06-budget | 가계부 | SwiftData, Swift Charts |

---

## 프로젝트별 특이사항

### 05-weather (날씨)
- 시뮬레이터에서 정상 작동
- 실기기에서는 네트워크 허용 필요:
  `Info.plist` → `NSAppTransportSecurity` → `NSAllowsArbitraryLoads: YES`
  또는 Xcode → Signing & Capabilities → **App Sandbox** 체크

### 06-budget (가계부)
- **Swift Charts** 사용: iOS 16+, Xcode 14+
- **SwiftData** 사용: iOS 17+, Xcode 15 필수
- `.modelContainer(for: Transaction.self)` 자동으로 DB 파일 생성
