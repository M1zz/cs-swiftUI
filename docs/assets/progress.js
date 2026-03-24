// ═══════════════════════════════════════════════
//  개발자리 — LocalStorage 기반 진행률 추적
//  외부 서비스 없이 브라우저에 저장
// ═══════════════════════════════════════════════

(function() {
  var STORAGE_KEY = 'gaebaljari_progress';

  function getProgress() {
    try {
      return JSON.parse(localStorage.getItem(STORAGE_KEY)) || {};
    } catch(e) { return {}; }
  }

  function saveProgress(data) {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    } catch(e) {}
  }

  window.GaebalProgress = {
    isComplete: function(chapter) {
      return !!getProgress()[chapter];
    },

    markComplete: function(chapter) {
      var p = getProgress();
      p[chapter] = new Date().toISOString();
      saveProgress(p);
      if (window.trackComplete) window.trackComplete(chapter);
      this.updateUI();
    },

    toggleComplete: function(chapter) {
      var p = getProgress();
      if (p[chapter]) {
        delete p[chapter];
      } else {
        p[chapter] = new Date().toISOString();
        if (window.trackComplete) window.trackComplete(chapter);
      }
      saveProgress(p);
      this.updateUI();
    },

    getCompletedCount: function() {
      return Object.keys(getProgress()).length;
    },

    getAll: function() {
      return getProgress();
    },

    updateUI: function() {
      var progress = getProgress();

      // 인덱스 페이지: 챌린지 카드에 완료 뱃지
      document.querySelectorAll('[data-chapter]').forEach(function(el) {
        var ch = el.getAttribute('data-chapter');
        var badge = el.querySelector('.complete-badge');
        if (progress[ch]) {
          if (!badge) {
            badge = document.createElement('span');
            badge.className = 'complete-badge';
            badge.textContent = 'CLEAR';
            el.appendChild(badge);
          }
          el.classList.add('is-complete');
        } else {
          if (badge) badge.remove();
          el.classList.remove('is-complete');
        }
      });

      // 프로그레스 바 업데이트
      var bar = document.getElementById('progress-fill');
      if (bar) {
        var total = document.querySelectorAll('[data-chapter]').length || 4;
        var done = 0;
        document.querySelectorAll('[data-chapter]').forEach(function(el) {
          if (progress[el.getAttribute('data-chapter')]) done++;
        });
        var pct = Math.round((done / total) * 100);
        bar.style.width = pct + '%';
        var label = document.getElementById('progress-label');
        if (label) label.textContent = done + ' / ' + total + ' CLEAR';
      }

      // 챌린지 페이지: 완료 버튼 상태
      var btn = document.getElementById('complete-btn');
      if (btn) {
        var ch = btn.getAttribute('data-chapter');
        if (progress[ch]) {
          btn.classList.add('completed');
          btn.textContent = 'CLEAR!';
        } else {
          btn.classList.remove('completed');
          btn.textContent = btn.getAttribute('data-label') || '챌린지 완료';
        }
      }
    }
  };

  // Stage 1 완료 모달
  window.GaebalProgress.checkStageComplete = function() {
    var chapters = ['1-1','1-2','1-3','1-4'];
    var progress = getProgress();
    var allDone = chapters.every(function(ch) { return !!progress[ch]; });
    if (!allDone) return;
    if (sessionStorage.getItem('gaebaljari_modal_shown')) return;
    sessionStorage.setItem('gaebaljari_modal_shown', '1');

    var overlay = document.createElement('div');
    overlay.id = 'stage-complete-modal';
    overlay.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,.6);backdrop-filter:blur(6px);z-index:9999;display:flex;align-items:center;justify-content:center;padding:20px;';
    overlay.innerHTML =
      '<div style="background:#fff;border-radius:20px;max-width:480px;width:100%;padding:40px 32px;text-align:center;position:relative;">' +
        '<button onclick="this.closest(\'#stage-complete-modal\').remove()" style="position:absolute;top:14px;right:14px;background:none;border:none;font-size:20px;cursor:pointer;color:#6B7190;">×</button>' +
        '<div style="font-size:48px;margin-bottom:16px;">🎉</div>' +
        '<div style="font-family:Space Grotesk,sans-serif;font-size:24px;font-weight:800;margin-bottom:8px;">Stage 1 완료!</div>' +
        '<div style="font-size:14px;color:#6B7190;line-height:1.7;margin-bottom:8px;">View, @State, @Binding, NavigationStack, Swift 문법을 배웠습니다.</div>' +
        '<div style="font-size:12px;color:#9BA3C0;margin-bottom:24px;">다음 단계로 넘어가세요.</div>' +
        '<div style="display:flex;flex-direction:column;gap:10px;">' +
          '<a href="swift-grammar.html" style="display:flex;align-items:center;gap:12px;padding:18px 20px;background:linear-gradient(135deg,#EDF6FF,#fff);border:2px solid #2E8BD8;border-radius:14px;text-decoration:none;transition:border-color .2s;">' +
            '<span style="font-size:24px;">🔩</span>' +
            '<div style="text-align:left;flex:1;">' +
              '<div style="display:flex;align-items:center;gap:8px;">' +
                '<span style="font-family:Space Grotesk,sans-serif;font-size:15px;font-weight:700;color:#1A1D2A;">Swift 핵심 문법 → Stage 2</span>' +
                '<span style="font-family:DM Mono,monospace;font-size:9px;padding:2px 6px;border-radius:100px;background:#2E8BD814;color:#2E8BD8;">추천</span>' +
              '</div>' +
              '<div style="font-size:11px;color:#6B7190;">struct vs class, Protocol 복습 후 Stage 2로 넘어가세요</div>' +
            '</div>' +
            '<span style="font-family:DM Mono,monospace;font-size:11px;color:#2E8BD8;">→</span>' +
          '</a>' +
        '</div>' +
      '</div>';
    document.body.appendChild(overlay);
    overlay.addEventListener('click', function(e) {
      if (e.target === overlay) overlay.remove();
    });
    if (typeof gtag === 'function') gtag('event', 'stage_complete', { stage: 'stage1' });
  };

  // 페이지 로드 시 UI 업데이트
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      GaebalProgress.updateUI();
      GaebalProgress.checkStageComplete();
    });
  } else {
    GaebalProgress.updateUI();
    GaebalProgress.checkStageComplete();
  }
})();
