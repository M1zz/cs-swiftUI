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
        '<div style="font-family:Syne,sans-serif;font-size:24px;font-weight:800;margin-bottom:8px;">Stage 1 완료!</div>' +
        '<div style="font-size:14px;color:#6B7190;line-height:1.7;margin-bottom:28px;">4개 챌린지를 모두 마쳤습니다.<br>다음 단계를 선택하세요.</div>' +
        '<div style="display:flex;flex-direction:column;gap:10px;">' +
          '<a href="clone-coding.html" style="display:flex;align-items:center;gap:12px;padding:16px 20px;background:linear-gradient(135deg,#FFF3ED,#fff);border:1px solid #FF6B2B44;border-radius:14px;text-decoration:none;transition:border-color .2s;" onmouseover="this.style.borderColor=\'#FF6B2B\'" onmouseout="this.style.borderColor=\'#FF6B2B44\'">' +
            '<span style="font-size:24px;">🛠</span>' +
            '<div style="text-align:left;flex:1;">' +
              '<div style="font-family:Syne,sans-serif;font-size:14px;font-weight:700;color:#1A1D2A;">클론 코딩 실전 프로젝트</div>' +
              '<div style="font-size:11px;color:#6B7190;">배운 개념으로 진짜 앱을 만들어보세요</div>' +
            '</div>' +
            '<span style="font-family:DM Mono,monospace;font-size:11px;color:#FF6B2B;">→</span>' +
          '</a>' +
          '<a href="stage2.html" style="display:flex;align-items:center;gap:12px;padding:16px 20px;background:linear-gradient(135deg,#EDF6FF,#fff);border:1px solid #5AB4FF44;border-radius:14px;text-decoration:none;transition:border-color .2s;" onmouseover="this.style.borderColor=\'#2E8BD8\'" onmouseout="this.style.borderColor=\'#5AB4FF44\'">' +
            '<span style="font-size:24px;">🏗</span>' +
            '<div style="text-align:left;flex:1;">' +
              '<div style="font-family:Syne,sans-serif;font-size:14px;font-weight:700;color:#1A1D2A;">Stage 2 — 제대로 만든다</div>' +
              '<div style="font-size:11px;color:#6B7190;">SwiftData · URLSession · Protocol · Animation</div>' +
            '</div>' +
            '<span style="font-family:DM Mono,monospace;font-size:11px;color:#2E8BD8;">→</span>' +
          '</a>' +
          '<a href="https://inf.run/4VzFE" target="_blank" rel="noopener" style="display:flex;align-items:center;gap:12px;padding:16px 20px;background:var(--surface,#F7F8FA);border:1px solid #E2E4EA;border-radius:14px;text-decoration:none;transition:border-color .2s;" onmouseover="this.style.borderColor=\'#FF6B2B\'" onmouseout="this.style.borderColor=\'#E2E4EA\'">' +
            '<span style="font-size:24px;">🧑‍💻</span>' +
            '<div style="text-align:left;flex:1;">' +
              '<div style="font-family:Syne,sans-serif;font-size:14px;font-weight:700;color:#1A1D2A;">1:1 멘토링 받기</div>' +
              '<div style="font-size:11px;color:#6B7190;">방향 설정, 포트폴리오 리뷰, 코드 리뷰</div>' +
            '</div>' +
            '<span style="font-family:DM Mono,monospace;font-size:11px;color:#6B7190;">→</span>' +
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
