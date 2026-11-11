/* ===================================================================
   Neovim desde cero - Presentation Engine
   =================================================================== */

(function () {
  'use strict';

  /* ---- State ---- */
  let deck = null;
  let flatSlides = []; // [{module, slideInModule, globalIndex, slide}]
  let cur = 0;
  let notesVisible = false;
  let overviewVisible = false;
  let helpVisible = false;
  let numBuffer = '';
  let numTimer = null;

  /* ---- Boot ---- */
  async function boot() {
    try {
      // deck.js (window.DECK) works from file://; deck.json needs a server.
      if (window.DECK) {
        deck = window.DECK;
      } else {
        const r = await fetch('deck.json');
        if (!r.ok) throw new Error('HTTP ' + r.status);
        deck = await r.json();
      }
    } catch (e) {
      showLoader(
        'Error al cargar deck.json',
        'Si abres desde file://, usa un servidor local:\n\n  python -m http.server\n\nLuego abre http://localhost:8000/course/slides/\n\n(' + e.message + ')',
        true
      );
      return;
    }
    hideLoader();
    buildIndex();
    cur = parseHash();
    render();
    window.addEventListener('keydown', onKey);
    window.addEventListener('resize', onResize);
    window.addEventListener('hashchange', onHashChange);
    onResize();
    document.getElementById('stage').addEventListener('click', next);
  }

  function buildIndex() {
    flatSlides = [];
    for (const mod of deck.modules) {
      for (let i = 0; i < mod.slides.length; i++) {
        flatSlides.push({ module: mod, slideInModule: i + 1, globalIndex: flatSlides.length, slide: mod.slides[i] });
      }
    }
  }

  /* ---- Navigation ---- */
  function goTo(idx, pushState) {
    cur = Math.max(0, Math.min(flatSlides.length - 1, idx));
    notesVisible = false;
    render();
    updateHash(pushState !== false);
  }
  function next() { goTo(cur + 1); }
  function prev() { goTo(cur - 1); }
  function goHome() { goTo(0); }
  function goEnd() { goTo(flatSlides.length - 1); }

  function goToModule(modNum) {
    const idx = flatSlides.findIndex(s => parseInt(s.module.number, 10) === modNum);
    if (idx >= 0) goTo(idx);
  }

  /* ---- Hash ---- */
  function updateHash(push) {
    if (!flatSlides.length) return;
    const s = flatSlides[cur];
    const hash = '#m' + s.module.number + '-' + s.slideInModule;
    if (push) {
      history.pushState(null, '', hash);
    } else {
      history.replaceState(null, '', hash);
    }
  }

  function parseHash() {
    const hash = location.hash.slice(1);
    const m = hash.match(/^m(\d+)-(\d+)$/);
    if (m) {
      const modNum = parseInt(m[1], 10);
      const slN = parseInt(m[2], 10);
      const idx = flatSlides.findIndex(s => parseInt(s.module.number, 10) === modNum && s.slideInModule === slN);
      if (idx >= 0) return idx;
    }
    return 0;
  }

  function onHashChange() {
    const idx = parseHash();
    if (idx !== cur) goTo(idx, false);
  }

  /* ---- Resize ---- */
  function onResize() {
    const wrapper = document.getElementById('stage-wrapper');
    if (!wrapper) return;
    const stage = document.getElementById('stage');
    const ww = wrapper.clientWidth;
    const wh = wrapper.clientHeight;
    const scale = Math.min(ww / 1280, wh / 720) * 0.97;
    const left = (ww - 1280 * scale) / 2;
    const top  = (wh - 720 * scale) / 2;
    stage.style.transform = 'scale(' + scale + ')';
    stage.style.left = left + 'px';
    stage.style.top  = top  + 'px';
  }

  /* ---- Keyboard ---- */
  function onKey(e) {
    if (overviewVisible) { handleOverviewKey(e); return; }
    if (helpVisible) { hideHelp(); return; }

    if (numTimer) {
      if (e.key >= '0' && e.key <= '9') { numBuffer += e.key; renderNumInput(); e.preventDefault(); return; }
      if (e.key === 'Enter') { commitNumJump(); e.preventDefault(); return; }
      if (e.key === 'Escape') { clearNumInput(); e.preventDefault(); return; }
    }

    switch (e.key) {
      case 'ArrowRight': case ' ': case 'PageDown': next(); e.preventDefault(); break;
      case 'ArrowLeft':  case 'PageUp':             prev(); e.preventDefault(); break;
      case 'Home': goHome(); break;
      case 'End':  goEnd();  break;
      case 'o': case 'O': toggleOverview(); e.preventDefault(); break;
      case 'f': case 'F': toggleFullscreen(); e.preventDefault(); break;
      case 'n': case 'N': toggleNotes(); break;
      case '?': showHelp(); break;
      case 'Escape': clearNumInput(); break;
      default:
        if (e.key >= '1' && e.key <= '9') {
          numBuffer = e.key;
          renderNumInput();
          startNumTimer();
          e.preventDefault();
        }
    }
  }

  function startNumTimer() {
    clearTimeout(numTimer);
    numTimer = setTimeout(clearNumInput, 4000);
  }

  function renderNumInput() {
    const el = document.getElementById('number-input');
    el.style.display = 'flex';
    el.querySelector('.ni-num').textContent = numBuffer;
  }

  function commitNumJump() {
    const n = parseInt(numBuffer, 10);
    clearNumInput();
    if (!isNaN(n) && n >= 0 && n <= 13) goToModule(n);
  }

  function clearNumInput() {
    clearTimeout(numTimer);
    numTimer = null;
    numBuffer = '';
    document.getElementById('number-input').style.display = 'none';
  }

  /* ---- Render ---- */
  function render() {
    if (!flatSlides.length) return;
    const s = flatSlides[cur];
    const stage = document.getElementById('stage');
    stage.innerHTML = '';
    const el = renderSlide(s.slide, s.module);
    stage.appendChild(el);

    // Progress bar
    const pct = flatSlides.length > 1 ? (cur / (flatSlides.length - 1)) * 100 : 100;
    document.getElementById('progress-bar').style.width = pct + '%';

    // Footer
    document.getElementById('module-label').textContent =
      'Mod. ' + s.module.number + ' · ' + s.module.title;
    document.getElementById('slide-counter').textContent =
      s.slideInModule + ' / ' + s.module.slides.length + '  ·  ' + (cur + 1) + ' / ' + flatSlides.length;

    // Notes
    if (notesVisible) showNotes(s.slide);
  }

  function renderSlide(slide, mod) {
    switch (slide.type) {
      case 'title':    return renderTitle(slide, mod);
      case 'concept':  return renderConcept(slide);
      case 'keys':     return renderKeys(slide);
      case 'demo':     return renderDemo(slide);
      case 'practice': return renderPractice(slide);
      case 'config':   return renderConfig(slide);
      case 'summary':  return renderSummary(slide);
      case 'locked':   return renderLocked(slide, mod);
      default:         return renderFallback(slide);
    }
  }

  /* Title */
  function renderTitle(sl, mod) {
    const d = div('slide slide-title');
    // Background image
    const bg = div('title-bg');
    bg.style.backgroundImage = "url('" + sl.image + "')";
    // Fallback: onerror on a hidden img
    const probe = document.createElement('img');
    probe.style.display = 'none';
    probe.src = sl.image;
    probe.onerror = () => { bg.style.backgroundImage = 'none'; d.querySelector('.placeholder-img').style.opacity = '0.07'; };
    d.appendChild(probe);
    d.appendChild(bg);
    // Placeholder icon
    const ph = div('placeholder-img');
    ph.textContent = '…'; // dots - hidden by bg image, shown if missing
    d.appendChild(ph);
    // Content
    const c = div('title-content');
    const num = div('module-number');
    num.textContent = sl.number || mod.number;
    const h1 = document.createElement('h1');
    h1.textContent = sl.heading;
    const p = document.createElement('p');
    p.className = 'title-promise';
    p.textContent = sl.promise;
    c.appendChild(num);
    c.appendChild(h1);
    c.appendChild(p);
    d.appendChild(c);
    return d;
  }

  /* Concept */
  function renderConcept(sl) {
    const d = div('slide slide-concept');
    d.appendChild(heading(sl.heading));
    const ul = document.createElement('ul');
    ul.className = 'bullets';
    for (const b of sl.bullets) {
      const li = document.createElement('li');
      li.textContent = b;
      ul.appendChild(li);
    }
    d.appendChild(ul);
    if (sl.notes) addNotesIndicator(d);
    return d;
  }

  /* Keys */
  function renderKeys(sl) {
    const d = div('slide slide-keys');
    d.appendChild(heading(sl.heading));
    const tbl = document.createElement('table');
    tbl.className = 'keys-table';
    const tb = document.createElement('tbody');
    for (const r of sl.rows) {
      const tr = document.createElement('tr');
      const kd = document.createElement('td');
      kd.className = 'key-col';
      kd.innerHTML = formatKeys(r.key);
      const ad = document.createElement('td');
      ad.className = 'action-col';
      ad.textContent = r.action;
      tr.appendChild(kd);
      tr.appendChild(ad);
      tb.appendChild(tr);
    }
    tbl.appendChild(tb);
    d.appendChild(tbl);
    return d;
  }

  /* Demo */
  function renderDemo(sl) {
    const d = div('slide slide-demo');
    d.appendChild(heading(sl.heading));

    if (sl.say) {
      const sayDiv = div('demo-say');
      sayDiv.textContent = sl.say;
      d.appendChild(sayDiv);
    }

    // Keys row
    const kr = div('demo-keys-row');
    const lbl = document.createElement('span');
    lbl.className = 'demo-label-text';
    lbl.textContent = 'Teclas:';
    kr.appendChild(lbl);
    const seq = div('demo-seq');
    seq.innerHTML = formatKeys(sl.keys);
    kr.appendChild(seq);
    d.appendChild(kr);

    // Panels
    const panels = div('demo-panels');

    // Before panel
    const before = div('demo-panel demo-before');
    const bl = div('demo-panel-label');
    bl.textContent = 'Antes';
    before.appendChild(bl);
    const bpre = document.createElement('pre');
    bpre.className = 'demo-code';
    bpre.innerHTML = renderTextWithCursor(sl.start, sl.cursor, false);
    before.appendChild(bpre);

    // Arrow
    const arr = div('demo-arrow');
    arr.textContent = '→';

    // After panel
    const after = div('demo-panel demo-after');
    const al = div('demo-panel-label');
    al.textContent = 'Después';
    after.appendChild(al);
    const apre = document.createElement('pre');
    apre.className = 'demo-code';
    apre.innerHTML = renderTextWithCursor(sl.result.text, sl.result.cursor, true);
    after.appendChild(apre);

    panels.appendChild(before);
    panels.appendChild(arr);
    panels.appendChild(after);
    d.appendChild(panels);
    return d;
  }

  function renderTextWithCursor(text, cursor, isAfter) {
    const lines = text.split('\n');
    const row = cursor[0];
    const col = cursor[1];
    const parts = [];
    for (let r = 0; r < lines.length; r++) {
      const line = lines[r];
      if (r === row) {
        const pre = esc(line.slice(0, col));
        const ch = esc(line[col] || ' ');
        const post = esc(line.slice(col + 1));
        const cls = 'cursor-block' + (isAfter ? ' cursor-after' : '');
        parts.push(pre + '<span class="' + cls + '">' + ch + '</span>' + post);
      } else {
        parts.push(esc(line));
      }
    }
    return parts.join('\n');
  }

  function getPracticeUrl(lesson) {
    const inCourse = location.pathname.includes('/course/slides/');
    return inCourse ? '../../practice/index.html#' + lesson : '../#' + lesson;
  }

  /* Practice */
  function renderPractice(sl) {
    const d = div('slide slide-practice');
    d.appendChild(heading(sl.heading || 'Ahora practica'));
    const box = div('practice-box');
    const cta = div('practice-cta');
    cta.textContent = 'Practica en la página de ejercicios';
    box.appendChild(cta);
    const practiceUrl = getPracticeUrl(sl.lesson);
    const a = document.createElement('a');
    a.href = practiceUrl;
    a.target = '_blank';
    a.className = 'practice-link';
    a.textContent = practiceUrl;
    box.appendChild(a);
    if (sl.public_url) {
      const pub = div('practice-public');
      pub.textContent = sl.public_url;
      box.appendChild(pub);
    }
    d.appendChild(box);
    return d;
  }

  /* Config */
  function renderConfig(sl) {
    const d = div('slide slide-config');
    d.appendChild(heading(sl.heading || 'Prueba estos atajos'));
    const tbl = document.createElement('table');
    tbl.className = 'config-table';
    const thead = document.createElement('thead');
    const htr = document.createElement('tr');
    for (const h of ['Atajo', 'Modo', 'Acción']) {
      const th = document.createElement('th');
      th.textContent = h;
      htr.appendChild(th);
    }
    thead.appendChild(htr);
    tbl.appendChild(thead);
    const tb = document.createElement('tbody');
    for (const r of sl.rows) {
      const tr = document.createElement('tr');
      const kd = document.createElement('td');
      kd.innerHTML = formatKeys(r.key);
      const md = document.createElement('td');
      md.className = 'td-mode';
      md.textContent = r.mode;
      const dd = document.createElement('td');
      dd.className = 'td-desc';
      dd.textContent = r.desc;
      tr.appendChild(kd);
      tr.appendChild(md);
      tr.appendChild(dd);
      tb.appendChild(tr);
    }
    tbl.appendChild(tb);
    d.appendChild(tbl);
    return d;
  }

  /* Summary */
  function renderSummary(sl) {
    const d = div('slide slide-summary');
    d.appendChild(heading(sl.heading || 'Resumen'));
    const ul = document.createElement('ul');
    ul.className = 'summary-bullets';
    for (const b of sl.bullets) {
      const li = document.createElement('li');
      li.textContent = b;
      ul.appendChild(li);
    }
    d.appendChild(ul);
    if (sl.cheatcode) {
      const pre = document.createElement('pre');
      pre.className = 'summary-cheatcode';
      pre.textContent = sl.cheatcode;
      d.appendChild(pre);
    }
    return d;
  }

  /* Fallback */
  function renderFallback(sl) {
    const d = div('slide');
    d.style.alignItems = 'center';
    d.style.justifyContent = 'center';
    const p = document.createElement('p');
    p.textContent = 'Slide tipo desconocido: ' + sl.type;
    p.style.color = '#888';
    d.appendChild(p);
    return d;
  }

  /* Locked (teaser only -- module continues at Academy) */
  function renderLocked(sl) {
    const d = div('slide slide-locked');
    const inner = div('locked-inner');
    const icon = div('locked-icon');
    icon.setAttribute('aria-hidden', 'true');
    inner.appendChild(icon);
    const h = document.createElement('h2');
    h.className = 'slide-heading locked-heading';
    h.textContent = sl.heading || 'Continua en Capdesis Academy';
    inner.appendChild(h);
    if (sl.body) {
      const p = document.createElement('p');
      p.className = 'locked-body';
      p.textContent = sl.body;
      inner.appendChild(p);
    }
    const a = document.createElement('a');
    a.className = 'locked-academy-link';
    a.href = sl.academy_url || '';
    a.target = '_blank';
    a.rel = 'noopener noreferrer';
    a.textContent = 'Ver curso completo gratis en Capdesis Academy';
    inner.appendChild(a);
    d.appendChild(inner);
    return d;
  }

  /* ---- Notes ---- */
  function toggleNotes() {
    notesVisible = !notesVisible;
    if (notesVisible && flatSlides.length) {
      showNotes(flatSlides[cur].slide);
    } else {
      document.getElementById('notes-panel').style.display = 'none';
    }
  }

  function showNotes(slide) {
    const panel = document.getElementById('notes-panel');
    const text = slide.notes || '';
    if (!text) { panel.style.display = 'none'; return; }
    panel.style.display = 'block';
    panel.innerHTML = '<div class="notes-label">Notas del profesor</div><p>' + esc(text) + '</p>';
  }

  function addNotesIndicator(parent) {
    const dot = div('');
    dot.style.cssText = 'position:absolute;right:20px;bottom:14px;width:8px;height:8px;border-radius:50%;background:#F3A63D;opacity:0.5;';
    parent.appendChild(dot);
  }

  /* ---- Overview ---- */
  function toggleOverview() {
    overviewVisible ? hideOverview() : showOverview();
  }

  function showOverview() {
    overviewVisible = true;
    const ov = document.getElementById('overview');
    ov.style.display = 'block';
    ov.innerHTML = '';
    const h = document.createElement('h2');
    h.textContent = 'Módulos del curso';
    ov.appendChild(h);
    const grid = div('');
    grid.id = 'overview-grid';
    const curMod = flatSlides[cur] ? flatSlides[cur].module.number : '00';
    for (const mod of deck.modules) {
      const cell = div('overview-cell' + (mod.number === curMod ? ' active' : ''));
      cell.tabIndex = 0;
      const num = div('ov-num');
      num.textContent = mod.number;
      const title = div('ov-title');
      title.textContent = mod.title;
      cell.appendChild(num);
      cell.appendChild(title);
      cell.addEventListener('click', () => { hideOverview(); goToModule(parseInt(mod.number, 10)); });
      cell.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { hideOverview(); goToModule(parseInt(mod.number, 10)); } });
      grid.appendChild(cell);
    }
    ov.appendChild(grid);
  }

  function hideOverview() {
    overviewVisible = false;
    document.getElementById('overview').style.display = 'none';
  }

  function handleOverviewKey(e) {
    if (e.key === 'Escape' || e.key === 'o' || e.key === 'O') { hideOverview(); e.preventDefault(); }
  }

  /* ---- Fullscreen ---- */
  function toggleFullscreen() {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(() => {});
    } else {
      document.exitFullscreen().catch(() => {});
    }
  }

  /* ---- Help ---- */
  function showHelp() {
    helpVisible = true;
    const hp = document.getElementById('help-panel');
    hp.style.display = 'flex';
    hp.innerHTML =
      '<div class="help-box">' +
      '<h2>Atajos de teclado</h2>' +
      '<table>' +
      row('→ / Espacio', 'Siguiente diapositiva') +
      row('← / RetrPag', 'Diapositiva anterior') +
      row('Inicio / Fin', 'Primera / última') +
      row('N + Enter', 'Saltar al módulo N (0-13)') +
      row('o', 'Vista general de módulos') +
      row('f', 'Pantalla completa') +
      row('n', 'Notas del profesor') +
      row('?', 'Esta ayuda') +
      row('Esc', 'Cerrar overlay') +
      '</table></div>';
    function row(k, v) { return '<tr><td><kbd>' + k + '</kbd></td><td>' + v + '</td></tr>'; }
  }

  function hideHelp() {
    helpVisible = false;
    document.getElementById('help-panel').style.display = 'none';
  }

  /* ---- Utilities ---- */
  function div(cls) {
    const d = document.createElement('div');
    if (cls) d.className = cls;
    return d;
  }

  function heading(text) {
    const h = document.createElement('h2');
    h.className = 'slide-heading';
    h.textContent = text;
    return h;
  }

  function esc(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  // Format a key string like "cwNEW<Esc>" or "<leader>ff" into HTML kbd badges
  function formatKeys(keyStr) {
    if (!keyStr) return '';
    // Tokenize: split on <...> first
    const tokens = [];
    let i = 0;
    while (i < keyStr.length) {
      if (keyStr[i] === '<') {
        const close = keyStr.indexOf('>', i);
        if (close !== -1) {
          tokens.push({ type: 'special', val: keyStr.slice(i + 1, close) });
          i = close + 1;
          continue;
        }
      }
      tokens.push({ type: 'char', val: keyStr[i] });
      i++;
    }
    // Render
    let html = '';
    let textAcc = '';
    for (const t of tokens) {
      if (t.type === 'char') {
        textAcc += esc(t.val);
      } else {
        if (textAcc) { html += '<span style="font-family:\'JetBrains Mono\',monospace;color:#D8D8E8;margin:0 1px">' + textAcc + '</span>'; textAcc = ''; }
        const label = t.val === 'Esc' ? 'Esc' : t.val === 'leader' ? 'SPC' : esc(t.val);
        html += '<kbd>' + label + '</kbd>';
      }
    }
    if (textAcc) html += '<span style="font-family:\'JetBrains Mono\',monospace;color:#D8D8E8;margin:0 1px">' + textAcc + '</span>';
    return html;
  }

  /* ---- Loader ---- */
  function showLoader(title, msg, isError) {
    let el = document.getElementById('loader');
    if (!el) {
      el = document.createElement('div');
      el.id = 'loader';
      document.getElementById('ui').appendChild(el);
    }
    el.innerHTML =
      '<div class="loader-title">' + esc(title) + '</div>' +
      (msg ? '<pre>' + esc(msg) + '</pre>' : '');
    el.style.display = 'flex';
  }

  function hideLoader() {
    const el = document.getElementById('loader');
    if (el) el.style.display = 'none';
  }

  /* ---- Start ---- */
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();
