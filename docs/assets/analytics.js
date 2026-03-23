// ═══════════════════════════════════════════════
//  개발자리 — Google Analytics 4 (촘촘 버전)
//  Measurement ID: G-FG0Q3EQFWM
// ═══════════════════════════════════════════════

(function () {
  var GA_ID = 'G-FG0Q3EQFWM';

  // ── GA4 스크립트 로드 ──────────────────────────
  var s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
  document.head.appendChild(s);

  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  window.gtag = gtag;
  gtag('js', new Date());

  // ── 페이지 분류 ───────────────────────────────
  var path = location.pathname;
  var page = path.split('/').pop() || 'index.html';
  var isEN = path.indexOf('/en/') !== -1;

  var PAGE_TYPE = (function () {
    if (page === 'index.html' || page === '') return 'landing';
    if (page === 'stage1.html') return 'stage1_overview';
    if (page === 'stage2.html') return 'stage2_overview';
    if (/^1-\d\.html/.test(page)) return 'challenge_s1';
    if (/^2-\d\.html/.test(page)) return 'challenge_s2';
    if (page === 'swift-grammar.html') return 'swift_grammar';
    if (page === 'clone-coding.html') return 'clone_coding';
    if (page === 'setup.html') return 'setup';
    if (page === 'blog.html') return 'blog';
    return 'other';
  })();

  var CHAPTER = page.replace('.html', ''); // "1-1", "2-3" 등

  // ── 디바이스 ──────────────────────────────────
  var isMobile = /Mobi|Android|iPhone|iPad/i.test(navigator.userAgent);

  // ── 유저 여정 (localStorage) ──────────────────
  // 방문한 페이지를 누적 저장해 퍼널 분석에 활용
  var JOURNEY_KEY = 'devjari_journey';
  function getJourney() {
    try { return JSON.parse(localStorage.getItem(JOURNEY_KEY) || '[]'); } catch(e) { return []; }
  }
  function saveJourney(arr) {
    try { localStorage.setItem(JOURNEY_KEY, JSON.stringify(arr.slice(-30))); } catch(e) {}
  }
  var journey = getJourney();
  var isFirstVisit = journey.length === 0;
  if (journey.indexOf(page) === -1) { journey.push(page); saveJourney(journey); }

  // 방문한 Stage 단계
  var visitedStages = {
    setup:   journey.some(function(p){ return p === 'setup.html'; }),
    stage1:  journey.some(function(p){ return p === 'stage1.html'; }),
    ch11:    journey.some(function(p){ return p === '1-1.html'; }),
    ch12:    journey.some(function(p){ return p === '1-2.html'; }),
    ch13:    journey.some(function(p){ return p === '1-3.html'; }),
    ch14:    journey.some(function(p){ return p === '1-4.html'; }),
    grammar: journey.some(function(p){ return p === 'swift-grammar.html'; }),
    stage2:  journey.some(function(p){ return p === 'stage2.html'; }),
    clone:   journey.some(function(p){ return p === 'clone-coding.html'; })
  };

  // 진행 깊이 (0~9)
  var progressDepth = Object.values ? Object.values(visitedStages).filter(Boolean).length
    : ['setup','stage1','ch11','ch12','ch13','ch14','grammar','stage2','clone']
        .filter(function(k){ return visitedStages[k]; }).length;

  // ── GA4 config (enhanced measurement 포함) ────
  gtag('config', GA_ID, {
    page_title:        document.title,
    page_location:     location.href,
    // 커스텀 dimension
    page_type:         PAGE_TYPE,
    is_mobile:         isMobile ? 'mobile' : 'desktop',
    is_first_visit:    isFirstVisit ? 'true' : 'false',
    journey_depth:     String(progressDepth),
    lang:              isEN ? 'en' : 'ko'
  });

  // ── 헬퍼: 이벤트 공통 파라미터 ────────────────
  function base(extra) {
    var obj = {
      page_type:  PAGE_TYPE,
      page:       page,
      lang:       isEN ? 'en' : 'ko',
      device:     isMobile ? 'mobile' : 'desktop'
    };
    if (extra) { for (var k in extra) obj[k] = extra[k]; }
    return obj;
  }

  // ── 1. 스크롤 깊이 (25 / 50 / 75 / 100%) ──────
  var scrollTracked = {};
  window.addEventListener('scroll', function () {
    var h = document.documentElement;
    var scrollable = h.scrollHeight - h.clientHeight;
    if (scrollable <= 0) return;
    var pct = Math.round((h.scrollTop / scrollable) * 100);
    [25, 50, 75, 100].forEach(function (t) {
      if (pct >= t && !scrollTracked[t]) {
        scrollTracked[t] = true;
        gtag('event', 'scroll_depth', base({ depth: t + '%' }));
      }
    });
  }, { passive: true });

  // ── 2. 체류 시간 마일스톤 ─────────────────────
  var timeStart = Date.now();
  [30, 60, 180, 300].forEach(function (sec) {
    setTimeout(function () {
      gtag('event', 'time_on_page', base({
        seconds: sec,
        scroll_reached: scrollTracked[25] ? '25%+' : '0%'
      }));
    }, sec * 1000);
  });

  // ── 3. 페이지 이탈 시 실제 체류 시간 ──────────
  window.addEventListener('beforeunload', function () {
    var elapsed = Math.round((Date.now() - timeStart) / 1000);
    // sendBeacon 방식으로 확실히 전송
    var body = JSON.stringify({ name: 'page_exit', params: base({ elapsed_sec: elapsed }) });
    if (navigator.sendBeacon) {
      // GA4는 sendBeacon 직접 지원하지 않으므로 gtag 사용
    }
    gtag('event', 'page_exit', base({ elapsed_sec: elapsed }));
  });

  // ── 4. CTA 버튼 클릭 식별 ────────────────────
  // 주요 버튼을 텍스트/href로 분류해 어떤 CTA가 클릭됐는지 파악
  var CTA_PATTERNS = [
    { pattern: /inf\.run/,            label: 'mentoring_inflearn' },
    { pattern: /open\.kakao/,         label: 'kakao_openchat' },
    { pattern: /clone-coding/,        label: 'goto_clone_coding' },
    { pattern: /stage2/,              label: 'goto_stage2' },
    { pattern: /stage1/,              label: 'goto_stage1' },
    { pattern: /1-1\.html/,           label: 'challenge_1_1' },
    { pattern: /1-2\.html/,           label: 'challenge_1_2' },
    { pattern: /1-3\.html/,           label: 'challenge_1_3' },
    { pattern: /1-4\.html/,           label: 'challenge_1_4' },
    { pattern: /2-1\.html/,           label: 'challenge_2_1' },
    { pattern: /2-2\.html/,           label: 'challenge_2_2' },
    { pattern: /2-3\.html/,           label: 'challenge_2_3' },
    { pattern: /2-4\.html/,           label: 'challenge_2_4' },
    { pattern: /swift-grammar/,       label: 'swift_grammar' },
    { pattern: /swift-data-structures/, label: 'next_funnel_data_structures' },
    { pattern: /setup\.html/,         label: 'setup_guide' },
    { pattern: /github\.com/,         label: 'github_profile' },
  ];

  document.addEventListener('click', function (e) {
    var a = e.target.closest('a[href]');
    if (!a) return;
    var href = a.href || '';
    var text = (a.textContent || '').trim().substring(0, 60);
    var isExternal = href.indexOf(location.hostname) === -1 && href.indexOf('http') === 0;

    // CTA 분류
    var ctaLabel = 'other';
    for (var i = 0; i < CTA_PATTERNS.length; i++) {
      if (CTA_PATTERNS[i].pattern.test(href)) {
        ctaLabel = CTA_PATTERNS[i].label;
        break;
      }
    }

    // 외부 링크는 outbound_click으로 전환 추적
    if (isExternal) {
      gtag('event', 'outbound_click', base({
        cta_label: ctaLabel,
        link_url:  href,
        link_text: text
      }));

      // 멘토링 클릭은 별도 전환 이벤트
      if (ctaLabel === 'mentoring_inflearn') {
        gtag('event', 'conversion_mentoring', base({ link_text: text }));
      }
      // 카카오 클릭도 별도 전환
      if (ctaLabel === 'kakao_openchat') {
        gtag('event', 'conversion_kakao', base({ link_text: text }));
      }
      // 다음 퍼널(자료구조) 클릭 전환
      if (ctaLabel === 'next_funnel_data_structures') {
        gtag('event', 'conversion_next_funnel', base({
          destination: 'swift-data-structures',
          link_text: text,
          from_page: PAGE_TYPE
        }));
      }
    } else if (href) {
      // 내부 링크 클릭
      gtag('event', 'internal_click', base({
        cta_label: ctaLabel,
        link_url:  href,
        link_text: text
      }));
    }
  });

  // ── 5. 주요 섹션 노출 추적 (IntersectionObserver) ──
  if (typeof IntersectionObserver !== 'undefined') {

    // 섹션에 data-track 속성 자동 부여
    var SECTION_SELECTORS = [
      { sel: '.path-item.cc, [data-track="clone_coding_section"]', name: 'section_clone_coding' },
      { sel: '.path-item.s2, [data-track="stage2_section"]',       name: 'section_stage2_path' },
      { sel: '.creator-card, .creator-wrap',                       name: 'section_creator' },
      { sel: '.email-card',                                        name: 'section_notify' },
      // stage1.html 멘토링 카드
      { sel: '[href="https://inf.run/4VzFE"]',                     name: 'section_mentoring_cta' },
      // 다음 퍼널 배너 (자료구조)
      { sel: '[href*="swift-data-structures"]',                     name: 'section_next_funnel_ds' },
    ];

    SECTION_SELECTORS.forEach(function (item) {
      var el = document.querySelector(item.sel);
      if (!el) return;
      var tracked = false;
      new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting && !tracked) {
            tracked = true;
            gtag('event', 'section_view', base({ section_name: item.name }));
          }
        });
      }, { threshold: 0.4 }).observe(el);
    });

    // 클론코딩 카드 6개 각각 노출 추적
    var projCards = document.querySelectorAll('.proj-card, .chapter-card[data-chapter]');
    projCards.forEach(function (card) {
      var title = (card.querySelector('.proj-title, .ch-title') || {}).textContent || '';
      var chapter = card.getAttribute('data-chapter') || title.trim().substring(0, 20);
      var cardTracked = false;
      new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting && !cardTracked) {
            cardTracked = true;
            gtag('event', 'card_view', base({
              card_type:  card.classList.contains('proj-card') ? 'clone_project' : 'challenge',
              card_label: chapter
            }));
          }
        });
      }, { threshold: 0.5 }).observe(card);
    });
  }

  // ── 6. 챌린지 완료 (progress.js에서 호출) ────
  window.trackComplete = function (chapter) {
    gtag('event', 'challenge_complete', base({ chapter: chapter }));
    // 전환 이벤트로도 별도 기록
    gtag('event', 'conversion_challenge_complete', base({ chapter: chapter }));
  };

  // ── 7. swift-grammar.html — 토픽 섹션 진입 ──
  if (PAGE_TYPE === 'swift_grammar') {
    var topicSections = document.querySelectorAll('.content-section[data-preview]');
    topicSections.forEach(function (sec) {
      var topicLabel = (sec.querySelector('.cs-title') || {}).textContent || sec.getAttribute('data-preview');
      var tTracked = false;
      new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting && !tTracked) {
            tTracked = true;
            gtag('event', 'grammar_topic_view', base({ topic: topicLabel.trim().substring(0, 40) }));
          }
        });
      }, { threshold: 0.3 }).observe(sec);
    });
  }

  // ── 8. 챌린지 페이지 — 코드 블록 노출 ────────
  if (PAGE_TYPE === 'challenge_s1' || PAGE_TYPE === 'challenge_s2') {
    var codeBlocks = document.querySelectorAll('.code-block, .code-wrap');
    var codeCount = 0;
    codeBlocks.forEach(function (block, i) {
      new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            codeCount++;
            if (codeCount === 1 || codeCount === codeBlocks.length) {
              gtag('event', 'code_block_view', base({
                block_index: i + 1,
                total_blocks: codeBlocks.length,
                milestone: codeCount === 1 ? 'first' : 'last'
              }));
            }
          }
        });
      }, { threshold: 0.5 }).observe(block);
    });
  }

  // ── 9. 첫 방문 이벤트 ────────────────────────
  if (isFirstVisit) {
    gtag('event', 'first_visit_devjari', base({
      referrer: document.referrer ? document.referrer.substring(0, 100) : 'direct'
    }));
  }

  // ── 10. 유저 여정 깊이 리포트 ─────────────────
  // 일정 깊이 도달 시 퍼널 전환 이벤트 발화
  if (progressDepth >= 3) {
    gtag('event', 'funnel_stage1_started', base({ depth: progressDepth }));
  }
  if (visitedStages.ch14) {
    gtag('event', 'funnel_stage1_complete', base({ depth: progressDepth }));
  }
  if (visitedStages.clone) {
    gtag('event', 'funnel_clone_reached', base({ depth: progressDepth }));
  }

  // ── 11. 다음 퍼널 클릭 리포트 ──────────────────
  // swift-data-structures 링크가 있는 페이지에서 노출+클릭을 추적
  var dsLink = document.querySelector('a[href*="swift-data-structures"]');
  if (dsLink) {
    gtag('event', 'next_funnel_available', base({
      destination: 'swift-data-structures'
    }));
  }

})();
