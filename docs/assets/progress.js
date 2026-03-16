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

  // 페이지 로드 시 UI 업데이트
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      GaebalProgress.updateUI();
    });
  } else {
    GaebalProgress.updateUI();
  }
})();
