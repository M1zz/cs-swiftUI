// ═══════════════════════════════════════════════
//  개발자리 — Swift Syntax Highlighter
//  공용 하이라이터 (주석/문자열 충돌 방지)
// ═══════════════════════════════════════════════

function highlightSwift(el) {
  var html = el.textContent;
  html = html.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

  // 1. 문자열을 토큰으로 치환 (주석 내부 따옴표와 충돌 방지)
  var strings = [];
  html = html.replace(/"([^"]*?)"/g, function(m) {
    strings.push(m);
    return '__STR' + (strings.length - 1) + '__';
  });

  // 2. 주석 처리
  html = html.replace(/(\/\/.*)/gm, '<span class="cm">$1</span>');

  // 3. 문자열 복원
  html = html.replace(/__STR(\d+)__/g, function(m, i) {
    return '<span class="str">' + strings[parseInt(i)] + '</span>';
  });

  // 4. @속성, #매크로
  html = html.replace(/@(\w+)/g, '<span class="pr">@$1</span>');
  html = html.replace(/#(\w+)/g, '<span class="pr">#$1</span>');

  // 5. 키워드 (이미 삽입된 태그 보호)
  html = html.replace(/(<[^>]+>)|\b(struct|class|var|let|func|import|return|if|else|guard|for|in|case|enum|protocol|some|private|fileprivate|internal|public|open|true|false|nil|self|mutating|static|init|try|throw|throws|async|await|actor|do|catch|lazy|inout|defer|convenience|override|super|get|set|willSet|didSet|is|as|switch|any|extension|where|typealias|default)\b/g, function(m, tag, kw) {
    return tag || '<span class="kw">' + kw + '</span>';
  });

  // 6. 숫자
  html = html.replace(/\b(\d+\.?\d*)\b/g, '<span class="num">$1</span>');

  el.innerHTML = html;
}

// 자동 실행
document.querySelectorAll('.swift-code').forEach(highlightSwift);
