// ═══════════════════════════════════════════════
//  개발자리 — 공용 네비게이션
//  모든 페이지에서 동일한 nav를 렌더링
//  서브 아이템은 슬라이드 애니메이션으로 펼쳐짐
//  모바일: 햄버거 메뉴
// ═══════════════════════════════════════════════

(function() {
  var page = location.pathname.split('/').pop() || 'index.html';

  var s1Pages = ['index.html','setup.html','1-1.html','1-2.html','1-3.html','1-4.html'];
  var s2Pages = ['stage2.html','2-1.html','2-2.html','2-3.html','2-4.html'];
  var isS1 = s1Pages.indexOf(page) !== -1;
  var isS2 = s2Pages.indexOf(page) !== -1;

  // CSS 주입
  var style = document.createElement('style');
  style.textContent =
    // 서브 아이템 애니메이션
    '.nav-sub{max-width:0;opacity:0;overflow:hidden;white-space:nowrap;transition:max-width .35s cubic-bezier(.4,0,.2,1),opacity .3s ease;margin-left:0;margin-right:0;}' +
    '.nav-sub.show{max-width:60px;opacity:1;}' +
    '.nav-sub a{display:inline-block;}' +
    // 햄버거 버튼
    '.nav-hamburger{display:none;background:none;border:none;cursor:pointer;padding:8px;margin-left:auto;-webkit-tap-highlight-color:transparent;}' +
    '.nav-hamburger span{display:block;width:18px;height:2px;background:var(--text);margin:4px 0;border-radius:2px;transition:transform .25s,opacity .2s;}' +
    '.nav-hamburger.open span:nth-child(1){transform:rotate(45deg) translate(3px,4px);}' +
    '.nav-hamburger.open span:nth-child(2){opacity:0;}' +
    '.nav-hamburger.open span:nth-child(3){transform:rotate(-45deg) translate(3px,-4px);}' +
    // 모바일
    '@media(max-width:768px){' +
      '.nav-hamburger{display:block;}' +
      '.nav-links{display:none!important;position:absolute;top:100%;left:0;right:0;background:rgba(255,255,255,.97);backdrop-filter:blur(16px);flex-direction:column;padding:12px 20px 16px;border-bottom:1px solid var(--border);box-shadow:0 8px 24px rgba(0,0,0,.08);gap:2px;}' +
      '.nav-links.mobile-open{display:flex!important;}' +
      '.nav-links li{width:100%;}' +
      '.nav-links a{display:block;padding:10px 12px;border-radius:8px;width:100%;}' +
      '.nav-sub{max-width:none!important;opacity:1!important;overflow:visible;}' +
      '.nav-sub a{padding-left:28px!important;font-size:11px!important;}' +
    '}';
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
    ? '<a href="' + enPages[page] + '" class="nav-en-link" style="font-family:\'DM Mono\',monospace;font-size:10px;padding:4px 10px;border-radius:100px;border:1px solid var(--border2);color:var(--muted);text-decoration:none;margin-left:auto;">EN</a>'
    : '';

  var nav = document.querySelector('nav.nav');
  if (nav) {
    nav.innerHTML =
      '<a href="index.html" class="nav-logo">개발자<span>리</span></a>' +
      '<button class="nav-hamburger" aria-label="메뉴"><span></span><span></span><span></span></button>' +
      '<ul class="nav-links">' + items + '</ul>' +
      enLink;

    // 햄버거 토글
    var btn = nav.querySelector('.nav-hamburger');
    var links = nav.querySelector('.nav-links');
    btn.addEventListener('click', function() {
      btn.classList.toggle('open');
      links.classList.toggle('mobile-open');
    });

    // 모바일에서 링크 클릭 시 메뉴 닫기
    links.addEventListener('click', function(e) {
      if (e.target.tagName === 'A') {
        btn.classList.remove('open');
        links.classList.remove('mobile-open');
      }
    });

    // 서브 아이템 순차 애니메이션 (데스크톱)
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
