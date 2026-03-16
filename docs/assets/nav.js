// ═══════════════════════════════════════════════
//  개발자리 — 공용 네비게이션
//  모든 페이지에서 동일한 nav를 렌더링
// ═══════════════════════════════════════════════

(function() {
  var page = location.pathname.split('/').pop() || 'index.html';

  // Stage 1 컨텍스트: 서브 아이템 표시
  var s1Pages = ['index.html','setup.html','1-1.html','1-2.html','1-3.html','1-4.html'];
  var isS1 = s1Pages.indexOf(page) !== -1;

  // Stage 2 컨텍스트: 서브 아이템 표시
  var s2Pages = ['stage2.html','2-1.html','2-2.html','2-3.html','2-4.html'];
  var isS2 = s2Pages.indexOf(page) !== -1;

  function active(href) {
    return page === href ? ' class="active"' : '';
  }

  function activeStyled(href, style) {
    var cls = page === href ? 'active' : '';
    return ' class="' + cls + '" style="' + style + '"';
  }

  var items = '';

  // 시작하기
  items += '<li><a href="setup.html"' + active('setup.html') + '>시작하기</a></li>';

  // Stage 1 + sub
  var s1Active = (isS1 && page !== 'setup.html') ? ' class="active"' : '';
  items += '<li><a href="index.html"' + s1Active + '>Stage 1</a></li>';
  if (isS1) {
    items += '<li><a href="1-1.html"' + active('1-1.html') + '>1-1</a></li>';
    items += '<li><a href="1-2.html"' + active('1-2.html') + '>1-2</a></li>';
    items += '<li><a href="1-3.html"' + active('1-3.html') + '>1-3</a></li>';
    items += '<li><a href="1-4.html"' + active('1-4.html') + '>1-4</a></li>';
  }

  // Swift 문법
  items += '<li><a href="swift-grammar.html"' + activeStyled('swift-grammar.html', 'color:#a855f7;') + '>Swift 문법</a></li>';

  // Stage 2 + sub
  var s2Active = isS2 ? ' class="active"' : '';
  items += '<li><a href="stage2.html"' + s2Active + ' style="color:var(--blue);">Stage 2</a></li>';
  if (isS2) {
    items += '<li><a href="2-1.html"' + active('2-1.html') + '>2-1</a></li>';
    items += '<li><a href="2-2.html"' + active('2-2.html') + '>2-2</a></li>';
    items += '<li><a href="2-3.html"' + active('2-3.html') + '>2-3</a></li>';
    items += '<li><a href="2-4.html"' + active('2-4.html') + '>2-4</a></li>';
  }

  // Clone Coding
  items += '<li><a href="clone-coding.html"' + activeStyled('clone-coding.html', 'color:var(--orange);') + '>Clone Coding</a></li>';

  // EN 링크 (영어 버전이 있는 페이지만)
  var enPages = {
    'index.html': 'en/index.html',
    'setup.html': 'en/setup.html',
    '1-1.html': 'en/1-1.html',
    '1-2.html': 'en/1-2.html',
    '1-3.html': 'en/1-3.html',
    '1-4.html': 'en/1-4.html'
  };
  var enLink = enPages[page]
    ? '<a href="' + enPages[page] + '" style="font-family:\'DM Mono\',monospace;font-size:10px;padding:4px 10px;border-radius:100px;border:1px solid var(--border2);color:var(--muted);text-decoration:none;margin-left:auto;">EN</a>'
    : '';

  var nav = document.querySelector('nav.nav');
  if (nav) {
    nav.innerHTML =
      '<a href="index.html" class="nav-logo">개발자<span>리</span></a>' +
      '<ul class="nav-links">' + items + '</ul>' +
      enLink;
  }
})();
