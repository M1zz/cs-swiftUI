// ═══════════════════════════════════════════════
//  개발자리 — 공용 네비게이션
//  모든 페이지에서 동일한 nav를 렌더링
//  서브 아이템은 슬라이드 애니메이션으로 펼쳐짐
// ═══════════════════════════════════════════════

(function() {
  var page = location.pathname.split('/').pop() || 'index.html';

  var s1Pages = ['index.html','setup.html','1-1.html','1-2.html','1-3.html','1-4.html'];
  var s2Pages = ['stage2.html','2-1.html','2-2.html','2-3.html','2-4.html'];
  var isS1 = s1Pages.indexOf(page) !== -1;
  var isS2 = s2Pages.indexOf(page) !== -1;

  // 애니메이션 CSS 주입
  var style = document.createElement('style');
  style.textContent =
    '.nav-sub{max-width:0;opacity:0;overflow:hidden;white-space:nowrap;transition:max-width .35s cubic-bezier(.4,0,.2,1),opacity .3s ease,margin .35s ease;margin-left:0;margin-right:0;}' +
    '.nav-sub.show{max-width:60px;opacity:1;margin-left:0;margin-right:0;}' +
    '.nav-sub a{display:inline-block;}';
  document.head.appendChild(style);

  function active(href) {
    return page === href ? ' class="active"' : '';
  }

  function activeStyled(href, s) {
    var cls = page === href ? 'active' : '';
    return ' class="' + cls + '" style="' + s + '"';
  }

  function subItem(href, label, delay) {
    var cls = page === href ? 'active' : '';
    return '<li class="nav-sub" data-delay="' + delay + '"><a href="' + href + '" class="' + cls + '">' + label + '</a></li>';
  }

  var items = '';

  // 시작하기
  items += '<li><a href="setup.html"' + active('setup.html') + '>시작하기</a></li>';

  // Stage 1 + sub
  var s1Active = (isS1 && page !== 'setup.html') ? ' class="active"' : '';
  items += '<li><a href="index.html"' + s1Active + '>Stage 1</a></li>';
  if (isS1) {
    items += subItem('1-1.html', '1-1', 0);
    items += subItem('1-2.html', '1-2', 1);
    items += subItem('1-3.html', '1-3', 2);
    items += subItem('1-4.html', '1-4', 3);
  }

  // Swift 문법
  items += '<li><a href="swift-grammar.html"' + activeStyled('swift-grammar.html', 'color:#a855f7;') + '>Swift 문법</a></li>';

  // Stage 2 + sub
  var s2Active = isS2 ? ' class="active"' : '';
  items += '<li><a href="stage2.html"' + s2Active + ' style="color:var(--blue);">Stage 2</a></li>';
  if (isS2) {
    items += subItem('2-1.html', '2-1', 0);
    items += subItem('2-2.html', '2-2', 1);
    items += subItem('2-3.html', '2-3', 2);
    items += subItem('2-4.html', '2-4', 3);
  }

  // Clone Coding
  items += '<li><a href="clone-coding.html"' + activeStyled('clone-coding.html', 'color:var(--orange);') + '>Clone Coding</a></li>';

  // EN 링크
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

    // 서브 아이템 순차 애니메이션
    requestAnimationFrame(function() {
      var subs = nav.querySelectorAll('.nav-sub');
      subs.forEach(function(el) {
        var delay = parseInt(el.getAttribute('data-delay') || '0', 10);
        setTimeout(function() {
          el.classList.add('show');
        }, 80 + delay * 60);
      });
    });
  }
})();
