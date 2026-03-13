# 개발자리 CS 커리큘럼

> **Top-Down · Problem-Driven · App-First**
> 앱을 만들다 마주치는 문제를 해결하며 CS를 배운다

---

## 🗺 커리큘럼 구조

| Stage | 주제 | 핵심 문제 | 상태 |
|-------|------|-----------|------|
| 🛠 S1 | [일단 만든다](stage1/index.html) | 아무것도 없다 → 화면에 뭔가를 띄우고 싶다 | ✅ 학습 가능 |
| 🐢 S2 | 왜 이렇게 느려? | 스크롤이 버벅인다 / 검색 결과가 늦게 뜬다 | 🔜 준비 중 |
| 🍝 S3 | 코드가 스파게티가 됐다 | 기능이 늘자 파일이 1000줄 | 🔜 준비 중 |
| 💀 S4 | 앱이 죽는다 | EXC_BAD_ACCESS / 메모리 경고 | 🔜 준비 중 |
| 🌐 S5 | 서버 데이터가 필요하다 | API 호출, JSON 파싱, 로컬 저장 | 🔜 준비 중 |
| 🧊 S6 | UI가 버벅이고 앱이 멈춘다 | 네트워크 중 화면이 얼어붙는다 | 🔜 준비 중 |
| 🧪 S7 | 내 코드가 맞는지 모르겠다 | 배포 후 버그, 수정 두려움 | 🔜 준비 중 |
| 🔭 S8 | 더 깊이 알고 싶다 | 근본 원리가 궁금하다 | 🔜 준비 중 |

---

## 📱 Stage 1 — 일단 만든다

| 챕터 | 시작 문제 | 배우는 것 |
|------|-----------|-----------|
| [1-1 화면에 뭔가 띄우기](stage1/1-1.html) | "Hello World"를 앱에서 보고 싶다 | View, body, Stack, modifier, @main |
| [1-2 버튼 누르면 화면이 바뀌게](stage1/1-2.html) | 버튼을 눌렀는데 텍스트가 안 바뀐다 | @State, @Binding, List, NavigationStack |
| [1-3 여러 화면과 공유 상태](stage1/1-3.html) | 화면이 2개인데 데이터를 어떻게 공유하는가 | @StateObject, @EnvironmentObject, TabView |
| [1-4 막히는 Swift 문법](stage1/1-4.html) | 컴파일 에러가 나는데 왜 나는지 모른다 | Optional, Collection, Closure, 에러 해석 |

---

## 🏗 파일 구조

```
cs-swiftUI/
├── README.md
└── docs/
    ├── index.html          # Stage 1 개요 (4챕터 목록)
    ├── 1-1.html            # 화면에 뭔가 띄우기
    ├── 1-2.html            # 버튼 누르면 화면이 바뀌게
    ├── 1-3.html            # 여러 화면과 공유 상태
    ├── 1-4.html            # 막히는 Swift 문법
    └── assets/
        └── style.css       # 공통 스타일
```

---

## 🚀 GitHub Pages

👉 **[https://m1zz.github.io/cs-swiftUI/](https://m1zz.github.io/cs-swiftUI/)**

배포 방법:
1. 이 레포를 GitHub에 push
2. Settings → Pages → Source: `main` 브랜치 `/root` 선택

---

## 🎯 학습 철학

**Top-Down**: 먼저 만들고, 문제를 만나고, 그때 배운다.
기초를 다 배우고 시작하는 방식은 동기를 죽인다.

**Problem-Driven**: 각 챕터는 실제 개발 중 마주치는 문제에서 시작한다.
문제가 없으면 개념도 없다.

**App-First**: 모든 예시는 iOS 앱 개발 맥락 안에 있다.
추상적인 예제가 아닌 실제 코드로 배운다.

---

개발자리 · 20개 앱을 운영하는 10년차 iOS 개발자의 CS 커리큘럼
