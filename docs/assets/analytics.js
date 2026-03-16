// ═══════════════════════════════════════════════
//  개발자리 & LeeoNote — Google Analytics 4
//  m1zz.github.io 하위 프로젝트 공용 트래킹
//
//  설정 방법:
//  1. https://analytics.google.com → 속성 만들기
//  2. 웹 스트림 추가 → URL: m1zz.github.io
//  3. 측정 ID (G-XXXXXX) 를 아래에 입력
//  4. 같은 ID를 LeeoNote 프로젝트에도 적용하면
//     하나의 GA4 대시보드에서 두 사이트를 동시 분석 가능
// ═══════════════════════════════════════════════

(function() {
  var GA_ID = 'G-FG0Q3EQFWM';

  if (GA_ID === 'G-XXXXXXXXXX') return;

  // GA4 스크립트 로드
  var s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
  document.head.appendChild(s);

  window.dataLayer = window.dataLayer || [];
  function gtag(){ dataLayer.push(arguments); }
  window.gtag = gtag;
  gtag('js', new Date());
  gtag('config', GA_ID);

  // ── 프로젝트 식별 ──
  // pathname으로 어느 사이트인지 자동 구분
  var path = location.pathname;
  var project = path.indexOf('/cs-swiftUI') === 0 ? 'cs-swiftUI'
              : path.indexOf('/LeeoNote')   === 0 ? 'LeeoNote'
              : 'other';

  // 페이지뷰에 프로젝트 태그 추가
  gtag('set', 'user_properties', { project: project });

  // ── 커스텀 이벤트 ──

  // 챌린지 완료
  window.trackComplete = function(chapter) {
    gtag('event', 'challenge_complete', {
      chapter: chapter,
      project: project
    });
  };

  // 외부 링크 클릭 (멘토링, 인프런 등)
  document.addEventListener('click', function(e) {
    var a = e.target.closest('a[href]');
    if (!a) return;
    var href = a.href;
    if (href && href.indexOf(location.hostname) === -1 && href.indexOf('http') === 0) {
      gtag('event', 'outbound_click', {
        url: href,
        project: project,
        link_text: (a.textContent || '').trim().substring(0, 50)
      });
    }
  });

  // 스크롤 깊이 추적 (25%, 50%, 75%, 100%)
  var tracked = {};
  window.addEventListener('scroll', function() {
    var h = document.documentElement;
    var scrollable = h.scrollHeight - h.clientHeight;
    if (scrollable <= 0) return;
    var pct = Math.round((h.scrollTop / scrollable) * 100);
    [25, 50, 75, 100].forEach(function(t) {
      if (pct >= t && !tracked[t]) {
        tracked[t] = true;
        gtag('event', 'scroll_depth', {
          depth: t + '%',
          page: path,
          project: project
        });
      }
    });
  }, { passive: true });
})();
