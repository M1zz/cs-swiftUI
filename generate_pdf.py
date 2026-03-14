#!/usr/bin/env python3
"""개발자리 Stage 1 — SwiftUI 커리큘럼 PDF 생성"""

from fpdf import FPDF
import os

FONT_DIR = os.path.expanduser("~/Library/Fonts")
OUT = os.path.join(os.path.dirname(__file__), "docs", "개발자리_Stage1_SwiftUI.pdf")


class Book(FPDF):
    def __init__(self):
        super().__init__()
        self.add_font("Pretendard", "", os.path.join(FONT_DIR, "Pretendard-Regular.otf"))
        self.add_font("Pretendard", "B", os.path.join(FONT_DIR, "Pretendard-Bold.otf"))
        self.add_font("Pretendard", "I", os.path.join(FONT_DIR, "Pretendard-Light.otf"))
        self.set_auto_page_break(True, margin=25)

    def header(self):
        if self.page_no() > 1:
            self.set_font("Pretendard", "I", 8)
            self.set_text_color(150, 150, 150)
            self.cell(0, 8, "개발자리 · Stage 1 — 일단 만든다", align="R")
            self.ln(4)

    def footer(self):
        self.set_y(-15)
        self.set_font("Pretendard", "I", 8)
        self.set_text_color(150, 150, 150)
        self.cell(0, 10, str(self.page_no()), align="C")

    def cover_page(self):
        self.add_page()
        self.ln(60)
        self.set_font("Pretendard", "B", 42)
        self.set_text_color(30, 30, 42)
        self.cell(0, 18, "개발자리", align="C", new_x="LMARGIN", new_y="NEXT")
        self.ln(4)
        self.set_font("Pretendard", "B", 24)
        self.set_text_color(232, 93, 26)
        self.cell(0, 12, "Stage 1 — 일단 만든다", align="C", new_x="LMARGIN", new_y="NEXT")
        self.ln(12)
        self.set_font("Pretendard", "", 13)
        self.set_text_color(107, 113, 144)
        self.multi_cell(0, 7, "화면을 띄우고, 상태를 관리하고,\n여러 화면을 연결하고, Swift 문법의 벽을 넘는다.", align="C")
        self.ln(30)
        self.set_font("Pretendard", "I", 10)
        self.cell(0, 6, "SwiftUI · @State · @Binding · NavigationStack · Optional · Closure", align="C")

    def toc_page(self):
        self.add_page()
        self.section_title("목차", color=(30, 30, 42))
        self.ln(4)
        toc = [
            ("준비: Xcode & Swift 설치", 3),
            ("챌린지 1-1: 화면에 뭔가 띄우기", None),
            ("  Topic 01  ContentView 구조", None),
            ("  Topic 02  기본 뷰 3종: Text · Image · Button", None),
            ("  Topic 03  Stack 3종: VStack · HStack · ZStack", None),
            ("  Topic 04  frame modifier", None),
            ("  Topic 05  padding · Spacer · offset", None),
            ("  Topic 06  GeometryReader", None),
            ("  Topic 07  @main · App · WindowGroup", None),
            ("  Topic 08  View 계층과 레이아웃", None),
            ("챌린지 1-2: 버튼 누르면 화면이 바뀌게", None),
            ("  Topic 01  SwiftUI 렌더링 루프", None),
            ("  Topic 02  @State · @Binding", None),
            ("  Topic 03  TextField", None),
            ("  Topic 04  Toggle · Slider · Picker", None),
            ("  Topic 05  List + ForEach + Identifiable", None),
            ("  Topic 06  NavigationStack · Sheet · Alert", None),
            ("  Topic 07  데이터 모델 설계", None),
            ("  Topic 08  UserDefaults + Codable", None),
            ("챌린지 1-3: 여러 화면과 공유 상태", None),
            ("  Topic 01  NavigationStack + NavigationPath", None),
            ("  Topic 02  sheet vs fullScreenCover", None),
            ("  Topic 03  @StateObject vs @ObservedObject", None),
            ("  Topic 04  @Observable · @EnvironmentObject", None),
            ("  Topic 05  TabView 기본 구성", None),
            ("챌린지 1-4: 막히는 Swift 문법", None),
            ("  Topic 01  let vs var · 타입 추론", None),
            ("  Topic 02  Optional 완전 정복", None),
            ("  Topic 03  Array · Dictionary · Set", None),
            ("  Topic 04  고차 함수 — map · filter · forEach", None),
            ("  Topic 05  클로저 문법 단계별 줄이기", None),
            ("  Topic 06  [weak self] 캡처 리스트", None),
            ("  Topic 07  자주 만나는 에러 메시지 4종", None),
            ("클론 코딩 추천", None),
        ]
        self.set_font("Pretendard", "", 11)
        self.set_text_color(30, 30, 42)
        for item, _ in toc:
            if item.startswith("  "):
                self.set_font("Pretendard", "", 10)
                self.set_text_color(107, 113, 144)
                self.cell(0, 7, item, new_x="LMARGIN", new_y="NEXT")
            else:
                self.set_font("Pretendard", "B", 11)
                self.set_text_color(30, 30, 42)
                self.ln(2)
                self.cell(0, 7, item, new_x="LMARGIN", new_y="NEXT")

    def section_title(self, text, color=(232, 93, 26)):
        self.set_font("Pretendard", "B", 22)
        self.set_text_color(*color)
        self.cell(0, 12, text, new_x="LMARGIN", new_y="NEXT")
        self.ln(2)

    def sub_title(self, text):
        self.set_font("Pretendard", "I", 11)
        self.set_text_color(107, 113, 144)
        self.cell(0, 6, text, new_x="LMARGIN", new_y="NEXT")
        self.ln(4)

    def topic_heading(self, num, title):
        self.ln(6)
        self.set_font("Pretendard", "B", 14)
        self.set_text_color(30, 30, 42)
        self.cell(0, 8, f"Topic {num:02d}   {title}", new_x="LMARGIN", new_y="NEXT")
        self.ln(2)

    def body_text(self, text):
        self.set_font("Pretendard", "", 10)
        self.set_text_color(50, 50, 60)
        self.multi_cell(0, 6, text)
        self.ln(2)

    def bullet(self, title, desc=""):
        self.set_font("Pretendard", "B", 10)
        self.set_text_color(232, 93, 26)
        self.cell(6, 6, "→")
        self.set_font("Pretendard", "B", 10)
        self.set_text_color(30, 30, 42)
        if desc:
            self.cell(0, 6, title, new_x="LMARGIN", new_y="NEXT")
            self.set_font("Pretendard", "", 9)
            self.set_text_color(107, 113, 144)
            self.cell(6, 5, "")
            self.multi_cell(0, 5, desc)
        else:
            self.cell(0, 6, title, new_x="LMARGIN", new_y="NEXT")
        self.ln(1)

    def code_block(self, code):
        self.set_fill_color(30, 31, 46)
        self.set_text_color(228, 230, 240)
        self.set_font("Pretendard", "", 9)
        x = self.get_x()
        y = self.get_y()
        lines = code.strip().split("\n")
        line_h = 5
        block_h = len(lines) * line_h + 10
        if y + block_h > self.h - 25:
            self.add_page()
            y = self.get_y()
        self.rect(x, y, self.w - 2 * self.l_margin, block_h, "F")
        self.set_xy(x + 6, y + 5)
        for line in lines:
            self.cell(0, line_h, line, new_x="LMARGIN", new_y="NEXT")
            self.set_x(x + 6)
        self.set_xy(x, y + block_h + 4)
        self.ln(2)

    def question_box(self, questions, color=(232, 93, 26)):
        self.set_fill_color(color[0], color[1], color[2])
        x = self.get_x()
        y = self.get_y()
        self.set_draw_color(*color)
        self.line(x, y, x, y + len(questions) * 7 + 12)
        self.set_xy(x + 4, y + 2)
        self.set_font("Pretendard", "B", 9)
        self.set_text_color(*color)
        self.cell(0, 5, "생각해보기", new_x="LMARGIN", new_y="NEXT")
        self.set_x(x + 4)
        self.set_font("Pretendard", "", 9)
        self.set_text_color(50, 50, 60)
        for q in questions:
            self.cell(0, 7, f"Q. {q}", new_x="LMARGIN", new_y="NEXT")
            self.set_x(x + 4)
        self.ln(4)

    def homework_section(self, title, tasks, checklist, color=(232, 93, 26)):
        self.ln(6)
        self.set_draw_color(220, 220, 225)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(6)
        self.set_font("Pretendard", "B", 9)
        self.set_text_color(*color)
        self.cell(0, 5, "HOMEWORK", new_x="LMARGIN", new_y="NEXT")
        self.set_font("Pretendard", "B", 16)
        self.set_text_color(30, 30, 42)
        self.cell(0, 10, title, new_x="LMARGIN", new_y="NEXT")
        self.ln(4)
        for tag, name, desc in tasks:
            self.set_font("Pretendard", "B", 9)
            self.set_text_color(*color)
            self.cell(20, 6, f"[{tag}]")
            self.set_font("Pretendard", "B", 10)
            self.set_text_color(30, 30, 42)
            self.cell(0, 6, name, new_x="LMARGIN", new_y="NEXT")
            self.set_font("Pretendard", "", 9)
            self.set_text_color(107, 113, 144)
            self.multi_cell(0, 5, desc)
            self.ln(2)
        self.ln(2)
        self.set_font("Pretendard", "B", 9)
        self.set_text_color(107, 113, 144)
        self.cell(0, 5, "완료 체크리스트", new_x="LMARGIN", new_y="NEXT")
        self.ln(2)
        self.set_font("Pretendard", "", 9)
        self.set_text_color(50, 50, 60)
        for item in checklist:
            self.cell(0, 6, f"[ ]  {item}", new_x="LMARGIN", new_y="NEXT")


def build():
    pdf = Book()

    # ── Cover ──
    pdf.cover_page()

    # ── TOC ──
    pdf.toc_page()

    # ── 준비: Xcode & Swift ──
    pdf.add_page()
    pdf.section_title("준비: Xcode & Swift 설치")
    pdf.sub_title("챌린지를 시작하기 전에 필요한 것은 딱 두 가지 — Mac과 Xcode")

    pdf.set_font("Pretendard", "B", 14)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 8, "Swift가 뭔가?", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)
    pdf.body_text("Apple이 2014년에 공개한 프로그래밍 언어. iOS/macOS/watchOS/visionOS 앱 개발의 표준 언어다.")
    pdf.bullet("안전하다", "Optional 시스템으로 null 크래시를 컴파일 시점에 잡는다")
    pdf.bullet("빠르다", "C++에 근접한 성능. 값 타입(struct) 중심 설계")
    pdf.bullet("읽기 쉽다", "세미콜론 없음, 타입 추론, 후행 클로저 등 간결한 문법")
    pdf.bullet("SwiftUI와 찰떡", "SwiftUI는 Swift 전용. 선언형 UI를 Swift 문법으로 작성")

    pdf.ln(4)
    pdf.set_font("Pretendard", "B", 14)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 8, "Xcode가 뭔가?", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)
    pdf.body_text("Apple이 만든 IDE(통합 개발 환경). 코드 편집, 빌드, 시뮬레이터, 앱 배포까지 전부 여기서 한다.")
    pdf.bullet("코드 에디터", "자동 완성, 구문 강조, 에러 표시, Fix-it 제안")
    pdf.bullet("Swift 컴파일러", "별도 설치 없이 포함되어 있다")
    pdf.bullet("iOS 시뮬레이터", "실기기 없이 iPhone/iPad에서 테스트")
    pdf.bullet("SwiftUI Preview", "빌드 없이 실시간으로 UI 확인")

    pdf.ln(4)
    pdf.set_font("Pretendard", "B", 14)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 8, "설치 방법", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)
    pdf.body_text("1. Mac App Store에서 \"Xcode\" 검색\n2. \"받기\" 클릭 (무료, 약 12~15GB)\n3. 처음 실행 → 추가 컴포넌트 설치\n4. Apple ID 로그인 (선택)")
    pdf.body_text("설치 확인: 새 프로젝트 생성 → iOS App → SwiftUI → ⌘R → 시뮬레이터에서 \"Hello, world!\" 확인")

    # ════════════════════════════════════════
    # 챌린지 1-1
    # ════════════════════════════════════════
    pdf.add_page()
    pdf.section_title("챌린지 1-1")
    pdf.set_font("Pretendard", "B", 18)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 10, "화면에 뭔가 띄우기", new_x="LMARGIN", new_y="NEXT")
    pdf.sub_title("\"Hello World\"를 앱에서 보고 싶다")

    # Topic 01
    pdf.topic_heading(1, "ContentView 구조")
    pdf.body_text("앱 시작점, struct가 View를 채택하는 이유")
    pdf.code_block("""struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .foregroundStyle(.orange)
    }
}""")
    pdf.question_box([
        "SwiftUI에서 View를 class가 아닌 struct로 만드는 이유는?",
        "some View에서 some을 빼면 어떤 에러가 나는가?",
        "#Preview와 시뮬레이터 빌드의 차이는?"
    ])
    pdf.bullet("struct ContentView: View", "SwiftUI View는 struct. 값 타입의 불변성이 렌더링 시스템과 맞닿는 지점")
    pdf.bullet("var body: some View", "View 프로토콜의 유일한 요구사항. Opaque Type")
    pdf.bullet("#Preview 매크로", "iOS 17+ Preview 매크로. 빌드 없이 실시간 UI 확인")

    # Topic 02
    pdf.topic_heading(2, "기본 뷰 3종: Text · Image · Button")
    pdf.code_block("""VStack(spacing: 16) {
    Text("개발자리")
        .font(.title)
        .bold()

    Image(systemName: "star.fill")
        .font(.system(size: 40))
        .foregroundStyle(.yellow)

    Button("시작하기") {
        print("탭!")
    }
    .buttonStyle(.borderedProminent)
}""")
    pdf.question_box([
        ".font()과 .bold()의 순서를 바꾸면 결과가 달라지는가?",
        "Image(systemName:)과 Image(\"이름\")의 차이는?",
        "Button의 action에서 print()를 호출하면 Preview에서 보이는가?"
    ])
    pdf.bullet("Text(\"Hello\")", ".font(), .foregroundStyle(), .bold() modifier 체이닝")
    pdf.bullet("Image(systemName:)", "SF Symbols 사용. .resizable() + .scaledToFit()")
    pdf.bullet("Button(action:label:)", "탭 액션 연결. 후행 클로저 문법")

    # Topic 03
    pdf.topic_heading(3, "Stack 3종: VStack · HStack · ZStack")
    pdf.code_block("""VStack(spacing: 20) {
    HStack {
        Text("왼쪽")
        Spacer()
        Text("오른쪽")
    }
    .padding()
    .background(.gray.opacity(0.1))
    .cornerRadius(8)

    ZStack {
        RoundedRectangle(cornerRadius: 12)
            .fill(.blue.opacity(0.15))
            .frame(height: 60)
        Text("ZStack 겹침")
    }
}""")
    pdf.question_box([
        "VStack(alignment: .leading)에서 기본값은?",
        "HStack 안에 Spacer()를 넣으면? 두 개 넣으면?",
        ".padding().background(.blue) vs .background(.blue).padding() 왜 다른가?"
    ])
    pdf.bullet("VStack — 수직 쌓기", "alignment: .leading/.center/.trailing, spacing 설정")
    pdf.bullet("HStack — 수평 쌓기", "alignment: .top/.center/.bottom")
    pdf.bullet("ZStack — 겹치기", "나중에 추가된 뷰가 위로")
    pdf.bullet("Modifier 체이닝 순서", ".padding().background() vs .background().padding()")

    # Topic 04
    pdf.topic_heading(4, "frame modifier")
    pdf.code_block("""VStack(spacing: 12) {
    Text("고정 크기")
        .frame(width: 120, height: 40)
        .background(.orange.opacity(0.2))
        .cornerRadius(8)

    Text("최대 너비")
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blue.opacity(0.15))
        .cornerRadius(8)
}""")
    pdf.bullet(".frame(width:height:)", "뷰를 담는 프레임에 크기를 주는 개념")
    pdf.bullet("maxWidth: .infinity", "부모가 주는 최대 너비를 다 차지")
    pdf.bullet("alignment 파라미터", "frame 안에서 자식 뷰의 위치 결정")

    # Topic 05
    pdf.topic_heading(5, "padding · Spacer · offset")
    pdf.code_block("""VStack {
    Spacer()
    Text("가운데 정렬")
        .padding()
        .background(.orange.opacity(0.15))
        .cornerRadius(8)
    Spacer()
}""")
    pdf.bullet(".padding()", "주변 여백 추가. .padding(.horizontal, 20) 방향별 지정")
    pdf.bullet("Spacer()", "남은 공간 전부 차지. Stack 안에서만 의미")
    pdf.bullet(".offset(x:y:)", "위치를 이동하지만 레이아웃 공간은 유지. padding과의 차이")

    # Topic 06
    pdf.topic_heading(6, "GeometryReader")
    pdf.code_block("""GeometryReader { geo in
    HStack(spacing: 0) {
        Color.orange
            .frame(width: geo.size.width * 0.3)
        Color.blue
    }
}
.frame(height: 60)
.cornerRadius(12)""")
    pdf.bullet("GeometryProxy", "geo.size.width, geo.size.height로 부모 크기 접근")
    pdf.bullet("주의사항", "GeometryReader는 최대 크기를 차지하려 한다")

    # Topic 07
    pdf.topic_heading(7, "@main · App · WindowGroup")
    pdf.code_block("""@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}""")
    pdf.bullet("@main 어트리뷰트", "진입점 마킹. 하나의 타입에만 붙일 수 있다")
    pdf.bullet("App 프로토콜", "body: some Scene 요구. 최상위 구조체")
    pdf.bullet("WindowGroup", "기본 Scene 타입. iPad/Mac 여러 창 지원")

    # Topic 08
    pdf.topic_heading(8, "View 계층과 레이아웃")
    pdf.code_block("""VStack {
    Text("padding 먼저")
        .padding()
        .background(.orange.opacity(0.2))

    Text("background 먼저")
        .background(.blue.opacity(0.2))
        .padding()
}""")
    pdf.bullet("크기 협상 과정", "부모가 제안 → 자식이 결정 → 부모가 배치")
    pdf.bullet("실기기 vs 시뮬레이터", "렌더링 성능, Metal, 카메라/센서 차이")

    # 1-1 Homework
    pdf.homework_section("챌린지 1-1을 마쳤다면", [
        ("필수", "자기소개 카드 만들기", "VStack, HStack, ZStack을 모두 사용해서 프로필 카드 만들기"),
        ("필수", "modifier 순서 실험", ".padding().background() vs .background().padding() 비교"),
        ("도전", "날씨 카드 UI 클론", "ZStack 그라디언트 배경 + GeometryReader 활용"),
    ], [
        "Text, Image, Button을 코드 없이 떠올릴 수 있다",
        "VStack/HStack/ZStack의 차이를 한 문장으로 설명할 수 있다",
        "modifier 순서가 결과를 바꾸는 이유를 안다",
        "@main → App → WindowGroup → ContentView 흐름을 그릴 수 있다",
    ])

    # ════════════════════════════════════════
    # 챌린지 1-2
    # ════════════════════════════════════════
    pdf.add_page()
    pdf.section_title("챌린지 1-2", color=(46, 139, 216))
    pdf.set_font("Pretendard", "B", 18)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 10, "버튼 누르면 화면이 바뀌게", new_x="LMARGIN", new_y="NEXT")
    pdf.sub_title("버튼을 눌렀는데 텍스트가 안 바뀐다")

    pdf.topic_heading(1, "SwiftUI 렌더링 루프")
    pdf.code_block("""struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("\\(count)")
                .font(.system(size: 60, weight: .bold))
            Button("+ 1") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
    }
}""")
    pdf.bullet("View는 struct — 불변이다", "상태가 바뀌면 새 View를 만든다")
    pdf.bullet("@State의 저장 위치", "View 바깥의 SwiftUI 저장소에 저장. 재생성되어도 값 유지")

    pdf.topic_heading(2, "@State · @Binding")
    pdf.code_block("""struct ParentView: View {
    @State private var name = ""
    var body: some View {
        VStack {
            Text("이름: \\(name)")
            ChildView(name: $name)
        }
    }
}

struct ChildView: View {
    @Binding var name: String
    var body: some View {
        TextField("이름 입력", text: $name)
            .textFieldStyle(.roundedBorder)
    }
}""")
    pdf.bullet("@State — View가 소유", "private으로 선언. 변경 시 자동 재렌더")
    pdf.bullet("@Binding — 참조를 전달", "$state로 전달. 부모의 State를 자식이 읽고 쓸 수 있음")
    pdf.bullet("단방향 데이터 흐름", "상태는 위에서 아래로")

    pdf.topic_heading(3, "TextField")
    pdf.code_block("""TextField("example@email.com", text: $email)
    .textFieldStyle(.roundedBorder)
    .keyboardType(.emailAddress)""")
    pdf.bullet("TextField(\"placeholder\", text: $name)", "Binding 전달. 입력 즉시 @State 업데이트")

    pdf.topic_heading(4, "Toggle · Slider · Picker")
    pdf.code_block("""Form {
    Toggle("다크 모드", isOn: $isDark)
    VStack(alignment: .leading) {
        Text("폰트 크기: \\(Int(fontSize))")
        Slider(value: $fontSize, in: 12...24, step: 1)
    }
}""")
    pdf.bullet("Toggle", "Bool @State에 바인딩")
    pdf.bullet("Slider", "범위 내 실수 값 선택. step:으로 스텝 설정")
    pdf.bullet("Picker", ".pickerStyle(.segmented) / .menu / .wheel")

    pdf.topic_heading(5, "List + ForEach + Identifiable")
    pdf.code_block("""struct Fruit: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
}

List {
    ForEach(fruits) { fruit in
        HStack {
            Text(fruit.emoji)
            Text(fruit.name)
        }
    }
    .onDelete { fruits.remove(atOffsets: $0) }
}""")
    pdf.bullet("Identifiable 프로토콜", "id 프로퍼티 필수. 최소한만 재렌더하기 위해")
    pdf.bullet("onDelete(perform:)", "스와이프 삭제. IndexSet으로 인덱스 전달")

    pdf.topic_heading(6, "NavigationStack · Sheet · Alert")
    pdf.code_block("""NavigationStack {
    List {
        NavigationLink("상세 보기") {
            Text("Detail View")
        }
    }
    .navigationTitle("홈")
    .sheet(isPresented: $showSheet) {
        Text("Sheet Content")
    }
}""")
    pdf.bullet("NavigationStack + NavigationLink", "스택 기반 화면 이동")
    pdf.bullet(".sheet(isPresented:)", "모달 표시/숨김")
    pdf.bullet(".alert(isPresented:)", "확인/취소 다이얼로그")

    pdf.topic_heading(7, "데이터 모델 설계")
    pdf.code_block("""struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
    }
}""")

    pdf.topic_heading(8, "UserDefaults + Codable 영속성")
    pdf.code_block("""// 저장
func save(_ todos: [Todo]) {
    if let data = try? JSONEncoder().encode(todos) {
        UserDefaults.standard.set(data, forKey: "todos")
    }
}

// 불러오기
func load() -> [Todo] {
    guard let data = UserDefaults.standard.data(forKey: "todos"),
          let todos = try? JSONDecoder().decode([Todo].self, from: data)
    else { return [] }
    return todos
}""")

    pdf.homework_section("챌린지 1-2를 마쳤다면", [
        ("필수", "카운터 앱 만들기", "+1, -1, 리셋 버튼. 0 미만이면 빨간색"),
        ("필수", "Todo 앱 완성", "TextField 입력 → List → 스와이프 삭제 → UserDefaults 저장"),
        ("도전", "설정 화면 만들기", "Toggle, Slider, Picker 조합. @Binding으로 데이터 전달"),
    ], [
        "@State 없이 var만 쓰면 왜 안 되는지 설명할 수 있다",
        "@State vs @Binding의 소유권 차이를 안다",
        "List + ForEach + Identifiable 조합을 쓸 수 있다",
        "UserDefaults + Codable로 데이터를 저장/불러올 수 있다",
    ], color=(46, 139, 216))

    # ════════════════════════════════════════
    # 챌린지 1-3
    # ════════════════════════════════════════
    pdf.add_page()
    pdf.section_title("챌린지 1-3", color=(45, 165, 93))
    pdf.set_font("Pretendard", "B", 18)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 10, "여러 화면과 공유 상태", new_x="LMARGIN", new_y="NEXT")
    pdf.sub_title("화면이 2개인데 데이터를 어떻게 공유하는가")

    pdf.topic_heading(1, "NavigationStack + NavigationPath")
    pdf.code_block("""@State private var path = NavigationPath()

NavigationStack(path: $path) {
    List {
        NavigationLink("프로필", value: "profile")
        NavigationLink("설정", value: "settings")
    }
    .navigationDestination(for: String.self) { value in
        Text("\\(value) 화면")
    }
}""")
    pdf.bullet("NavigationPath", "@State로 관리해 코드로 화면 이동")
    pdf.bullet("딥링크 처리", "onOpenURL에서 NavigationPath를 조작")

    pdf.topic_heading(2, "sheet vs fullScreenCover")
    pdf.code_block(""".sheet(isPresented: $showSheet) {
    Text("Sheet!")
        .presentationDetents([.medium, .large])
}
.fullScreenCover(isPresented: $showFull) {
    Text("Full Screen!")
}""")
    pdf.bullet(".sheet", "아래에서 올라오는 카드 형태. 가장 일반적인 모달")
    pdf.bullet(".fullScreenCover", "전체 화면 덮음. 카메라, 온보딩 등")
    pdf.bullet("dismiss", "@Environment(\\.dismiss) var dismiss")

    pdf.topic_heading(3, "@StateObject vs @ObservedObject")
    pdf.code_block("""class TodoStore: ObservableObject {
    @Published var items: [String] = []
}

// 부모: 소유
@StateObject var store = TodoStore()

// 자식: 구독
@ObservedObject var store: TodoStore""")
    pdf.bullet("@StateObject — 소유자", "객체를 처음 생성. View 재생성되어도 유지")
    pdf.bullet("@ObservedObject — 구독자", "외부에서 주입받아 구독")

    pdf.topic_heading(4, "@Observable · @EnvironmentObject")
    pdf.code_block("""@Observable
class UserSettings {
    var username = "개발자리"
    var isDarkMode = false
}

struct SettingsView: View {
    @Environment(UserSettings.self) var settings
    var body: some View {
        Text(settings.username)
    }
}""")
    pdf.bullet("@Observable (iOS 17+)", "@Published 없이도 동작. 훨씬 단순")
    pdf.bullet("@EnvironmentObject", "prop drilling 해결. 깊은 자식이 바로 꺼내 씀")

    pdf.topic_heading(5, "TabView 기본 구성")
    pdf.code_block("""TabView {
    HomeView()
        .tabItem { Label("홈", systemImage: "house") }
    SearchView()
        .tabItem { Label("검색", systemImage: "magnifyingglass") }
    ProfileView()
        .tabItem { Label("프로필", systemImage: "person") }
}""")
    pdf.bullet("탭별 독립 NavigationStack", "탭 전환 시 navigation 상태 각자 유지")

    pdf.homework_section("챌린지 1-3을 마쳤다면", [
        ("필수", "3탭 앱 만들기", "TabView + 각 탭에 NavigationStack"),
        ("필수", "공유 데이터 모델", "@Observable class로 앱 전체 상태 관리"),
        ("도전", "메모 앱", "List → 상세(push) → 새 메모(sheet)"),
    ], [
        "NavigationStack과 sheet의 사용 시점 차이를 안다",
        "@StateObject vs @ObservedObject를 올바르게 쓸 수 있다",
        "@Observable (iOS 17+) 방식을 이해하고 쓸 수 있다",
        "TabView 안에 독립적인 NavigationStack을 넣을 수 있다",
    ], color=(45, 165, 93))

    # ════════════════════════════════════════
    # 챌린지 1-4
    # ════════════════════════════════════════
    pdf.add_page()
    pdf.section_title("챌린지 1-4", color=(212, 149, 10))
    pdf.set_font("Pretendard", "B", 18)
    pdf.set_text_color(30, 30, 42)
    pdf.cell(0, 10, "막히는 Swift 문법", new_x="LMARGIN", new_y="NEXT")
    pdf.sub_title("컴파일 에러가 나는데 왜 나는지 모른다")

    pdf.topic_heading(1, "let vs var · 타입 추론")
    pdf.code_block("""let name = "개발자리"     // String 추론
let age: Int = 10         // 명시적 타입
var score = 0             // 변경 가능

score += 10
// name = "다른이름"      // 컴파일 에러!""")
    pdf.bullet("let — 상수", "한 번 할당하면 변경 불가. 기본적으로 let을 쓰고 필요할 때 var")
    pdf.bullet("타입 추론 vs 명시", "타입이 모호하거나 다른 타입을 원할 때 명시")

    pdf.topic_heading(2, "Optional 완전 정복")
    pdf.code_block("""var nickname: String? = nil

// if let 언래핑
if let name = nickname {
    print("닉네임: \\(name)")
} else {
    print("닉네임 없음")
}

// ?? nil 병합
let display = nickname ?? "익명"

// 옵셔널 체이닝
let count = nickname?.count""")
    pdf.bullet("Optional이란", "String? = 값이 있거나 없거나. enum: some(Wrapped), none")
    pdf.bullet("if let", "값이 있으면 블록 실행. 블록 안에서만 사용 가능")
    pdf.bullet("guard let", "없으면 early return. 이후 코드에서 계속 사용")
    pdf.bullet("?? nil 병합", "nil일 때 기본값")
    pdf.bullet("! 강제 언래핑", "nil이면 crash. 100% 확신할 때만")

    pdf.topic_heading(3, "Array · Dictionary · Set")
    pdf.code_block("""var fruits = ["사과", "바나나", "포도"]
fruits.append("딸기")

let scores: [String: Int] = ["수학": 90, "영어": 85]
print(scores["수학"] ?? 0)

let tags: Set = ["Swift", "iOS", "Swift"]
print(tags.count)  // 2 (중복 제거)""")
    pdf.bullet("Array", "순서 있는 목록. 인덱스로 접근")
    pdf.bullet("Dictionary", "키-값 쌍. dict[\"key\"] 결과는 항상 Optional")
    pdf.bullet("Set", "중복 없는 집합. contains()가 O(1)")

    pdf.topic_heading(4, "고차 함수 — map · filter · reduce")
    pdf.code_block("""let numbers = [1, 2, 3, 4, 5]

let doubled = numbers.map { $0 * 2 }       // [2,4,6,8,10]
let evens = numbers.filter { $0 % 2 == 0 } // [2, 4]
let sum = numbers.reduce(0, +)              // 15

let strings = ["1", "a", "3"]
let nums = strings.compactMap { Int($0) }   // [1, 3]""")
    pdf.bullet("map — 변환", "각 요소를 변환해 새 배열 반환")
    pdf.bullet("filter — 걸러내기", "조건에 맞는 요소만 새 배열로")
    pdf.bullet("compactMap", "map + nil 제거")
    pdf.bullet("reduce — 합산", "누적값 계산")

    pdf.topic_heading(5, "클로저 문법 단계별 줄이기")
    pdf.code_block("""// 1. 기본
names.sorted(by: { (a: String, b: String) -> Bool in
    return a < b
})
// 2. 타입 추론
names.sorted(by: { a, b in a < b })
// 3. 단축 인자명
names.sorted(by: { $0 < $1 })
// 4. 후행 클로저
names.sorted { $0 < $1 }""")
    pdf.bullet("$0, $1", "파라미터 이름 생략. 순서대로 $0, $1, ...")
    pdf.bullet("후행 클로저", "마지막 파라미터가 클로저면 괄호 밖으로")

    pdf.topic_heading(6, "[weak self] 캡처 리스트")
    pdf.code_block("""// 클래스에서 비동기 콜백 — [weak self] 필요
URLSession.shared.dataTask(with: url) {
    [weak self] data, _, _ in
    guard let self else { return }
    self.data = String(data: data!, encoding: .utf8)
}

// SwiftUI View에서는 불필요 (struct이므로)
Button("탭") { print("no [weak self] needed") }""")
    pdf.bullet("[weak self] 필요한 경우", "escape 클로저(비동기 콜백, 타이머)에서 self 참조 시")
    pdf.bullet("SwiftUI에서는 불필요", "View는 struct — 순환 참조 없음")

    pdf.topic_heading(7, "자주 만나는 에러 메시지 4종")
    pdf.code_block("""// Cannot convert value of type 'Int'
// to expected argument type 'String'
let text: String = String(42)  // 명시적 변환

// Value of optional type 'String?'
// must be unwrapped
if let name { print("Hello " + name) }""")
    pdf.bullet("Cannot convert value of type", "타입 불일치. 명시적 변환 필요")
    pdf.bullet("must be unwrapped", "Optional을 그대로 사용. if let / guard let / ??")
    pdf.bullet("requires ... 'Equatable'", "커스텀 타입에 Equatable 채택 필요")
    pdf.bullet("Fix-it 신뢰도", "프로토콜 추가, import 추가는 OK. 복잡한 타입 문제는 주의")

    pdf.homework_section("챌린지 1-4를 마쳤다면", [
        ("필수", "Optional 연습장", "String?, Int?, [String]? — if let, guard let, ??, 옵셔널 체이닝"),
        ("필수", "고차 함수로 데이터 가공", "map으로 이름 추출, filter로 80점 이상, reduce로 평균"),
        ("도전", "클로저 단계별 줄이기", "sorted, filter, map 각각 4단계로 줄여보기"),
    ], [
        "Optional이 enum이라는 것을 안다",
        "if let / guard let / ?? 를 상황에 맞게 쓸 수 있다",
        "map, filter, reduce를 for문 대신 쓸 수 있다",
        "[weak self]가 필요한 경우와 불필요한 경우를 구분할 수 있다",
    ], color=(212, 149, 10))

    # ════════════════════════════════════════
    # 클론 코딩 추천
    # ════════════════════════════════════════
    pdf.add_page()
    pdf.section_title("클론 코딩 추천")
    pdf.sub_title("Stage 1을 마쳤다면 만들어볼 것들")
    pdf.ln(4)

    clones = [
        ("[1] 계산기", "Apple 기본 계산기 UI 클론. Grid 레이아웃, 버튼 스타일링, @State로 연산 로직", "1-1 레이아웃 / 1-2 @State"),
        ("[2] 타이머 / 스톱워치", "Apple Clock 앱의 타이머 탭 클론. Timer.publish, 원형 프로그레스 바", "1-1 레이아웃 / 1-2 @State / 1-4 클로저"),
        ("[3] 장바구니 앱", "상품 목록 -> 장바구니 담기 -> 수량 조절 -> 총 금액 계산", "1-2 List / 1-3 상태 공유 / 1-4 고차함수"),
        ("[4] 메모 앱", "메모 작성/편집/삭제. TabView + NavigationStack + .searchable", "1-2 CRUD / 1-3 화면 구조 / 1-4 Optional"),
        ("[5] 날씨 앱 UI", "Apple Weather UI 클론. ScrollView, ZStack 그라디언트, GeometryReader", "1-1 ZStack / 1-1 GeometryReader / 1-4 모델링"),
        ("[6] 가계부 앱", "수입/지출 기록, 카테고리별 필터, 월별 합계. 종합 프로젝트", "Stage 1 전체"),
    ]
    for title, desc, tags in clones:
        pdf.set_font("Pretendard", "B", 13)
        pdf.set_text_color(30, 30, 42)
        pdf.cell(0, 8, title, new_x="LMARGIN", new_y="NEXT")
        pdf.set_font("Pretendard", "", 10)
        pdf.set_text_color(107, 113, 144)
        pdf.multi_cell(0, 5, desc)
        pdf.set_font("Pretendard", "I", 9)
        pdf.set_text_color(232, 93, 26)
        pdf.cell(0, 5, tags, new_x="LMARGIN", new_y="NEXT")
        pdf.ln(6)

    # ── Save ──
    pdf.output(OUT)
    print(f"PDF 생성 완료: {OUT}")
    print(f"총 {pdf.page_no()} 페이지")


if __name__ == "__main__":
    build()
