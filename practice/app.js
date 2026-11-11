/**
 * Vim Practice - interactive browser trainer
 * Uses CodeMirror 6 with @replit/codemirror-vim for real vim key handling.
 */

import {
  EditorView,
  keymap,
  lineNumbers,
  drawSelection,
  highlightActiveLine,
  highlightActiveLineGutter,
} from "./vendor/codemirror.js";
import { EditorState, Prec } from "./vendor/codemirror.js";
import { defaultKeymap, historyKeymap, history } from "./vendor/codemirror.js";
import { oneDark } from "./vendor/codemirror.js";
import { vim, Vim, getCM } from "./vendor/codemirror.js";
import { indentUnit } from "./vendor/codemirror.js";

// ---------------------------------------------------------------------------
// Globals
// ---------------------------------------------------------------------------

let CURRENT_LESSON = null;
let DATA = null;          // parsed exercises.json
let LANG = "es";          // "es" | "en"
let PROGRESS = new Set(); // completed exercise IDs
let editors = new Map();  // exerciseId -> { view, cm, done }

const STORAGE_KEY = "vim-practice-progress-v1";
const LANG_KEY    = "vim-practice-lang-v1";

// ---------------------------------------------------------------------------
// Token verification helpers (Bug 1 fix: false-positive prevention)
// ---------------------------------------------------------------------------

// Port of Python's normal_commands() in tests/test_practice.py.
// Extracts normal-mode command tokens from a vim key sequence, skipping text
// typed in insert/replace mode, char arguments after f/t/F/T/r, register
// names after "/q/@, and search text after //?/:.
// Returns an array of token strings, e.g. ["count","gg","j"] for "3ggj".
function normalCommands(keys) {
  const tokens = [];
  let p = 0;
  while (p < keys.length) {
    if (keys[p] === "<") {
      const e = keys.indexOf(">", p + 1);
      if (e !== -1) { tokens.push(keys.slice(p, e + 1)); p = e + 1; continue; }
    }
    tokens.push(keys[p]);
    p++;
  }

  const out = [];
  let i = 0;

  function until(stopSet) {
    while (i < tokens.length && !stopSet.has(tokens[i])) i++;
    i++; // consume the stop token
  }

  while (i < tokens.length) {
    const t = tokens[i++];

    // Count: digits 1-9 (0 is the goto-col-0 command, not a count by itself)
    if (t.length === 1 && t >= "1" && t <= "9") {
      out.push("count");
      continue;
    }

    // Insert/Replace mode: skip typed text until <Esc>
    if (t === "i" || t === "a" || t === "I" || t === "A" || t === "o" ||
        t === "O" || t === "R" || t === "s" || t === "S" || t === "C") {
      out.push(t);
      until(new Set(["<Esc>"]));
      continue;
    }

    // f, t, F, T, r: skip one character argument
    if (t === "f" || t === "t" || t === "F" || t === "T" || t === "r") {
      out.push(t);
      i++;
      continue;
    }

    // ", q, @: skip register/macro name
    if (t === '"' || t === "q" || t === "@") {
      out.push(t);
      i++;
      continue;
    }

    // /, ?, :: skip search/command text until <CR>
    if (t === "/" || t === "?" || t === ":") {
      out.push(t);
      until(new Set(["<CR>"]));
      continue;
    }

    // g combines with next char (gg, ge, gE, g~, etc.)
    if (t === "g") {
      const nxt = i < tokens.length ? tokens[i] : "";
      out.push("g" + nxt);
      if (nxt) i++;
      continue;
    }

    // Operators: d, c, y, >, <
    if (t === "d" || t === "c" || t === "y" || t === ">" || t === "<") {
      out.push(t);
      const nxt = i < tokens.length ? tokens[i] : "";
      if ((nxt === "i" || nxt === "a") && i + 1 < tokens.length) {
        out.push(nxt + tokens[i + 1]); // text object: iw, a(, etc.
        i += 2;
      } else if (nxt === "f" || nxt === "t" || nxt === "F" || nxt === "T") {
        out.push(nxt);
        i += 2; // skip nxt and its char argument
      } else if (nxt === "g") {
        out.push("g" + (i + 1 < tokens.length ? tokens[i + 1] : ""));
        i += 2;
      } else if (nxt) {
        out.push(nxt !== t ? nxt : t); // motion or doubled operator (dd, cc)
        i++;
      }
      if (t === "c") until(new Set(["<Esc>"])); // c enters insert mode
      continue;
    }

    out.push(t);
  }
  return out;
}

// Returns true if `required` is an ordered subsequence of `actual`.
function isSubsequence(required, actual) {
  let j = 0;
  for (let i = 0; i < actual.length && j < required.length; i++) {
    if (actual[i] === required[j]) j++;
  }
  return j === required.length;
}

// Returns true if `actual` is a non-empty proper prefix of `required`.
// This handles exercises where the expected state matches at an intermediate
// point in the full key sequence (e.g. macro exercises where @a changes state
// AWAY from the expected state, so the check must fire mid-sequence).
function isPrefixOf(required, actual) {
  if (actual.length === 0 || actual.length > required.length) return false;
  for (let i = 0; i < actual.length; i++) {
    if (actual[i] !== required[i]) return false;
  }
  return true;
}

// Convert a KeyboardEvent to a vim-notation token string.
// Returns null for keys that have no vim-command meaning.
function keyEventToVimToken(e) {
  const key = e.key;
  if (key === "Control" || key === "Shift" || key === "Alt" || key === "Meta" ||
      key === "CapsLock" || key === "NumLock" || key === "ScrollLock") return null;
  if (/^(Arrow|F\d|Home|End|Page|Insert|Delete|Scroll|Pause|Print)/.test(key)) return null;
  if (key === "Escape")    return "<Esc>";
  if (key === "Enter")     return "<CR>";
  if (key === "Backspace") return "<BS>";
  if (key === "Tab")       return "<Tab>";
  if (e.ctrlKey && key.length === 1) return "<C-" + key.toLowerCase() + ">";
  if (key.length === 1 && !e.ctrlKey && !e.altKey && !e.metaKey) return key;
  return null;
}

// Split a key sequence into human-readable command strings for the hint.
// "3ggj" => ["3gg", "j"]   "itext<Esc>" => ["i"]
function keysToHintList(keys) {
  const toks = [];
  let p = 0;
  while (p < keys.length) {
    if (keys[p] === "<") {
      const e = keys.indexOf(">", p + 1);
      if (e !== -1) { toks.push(keys.slice(p, e + 1)); p = e + 1; continue; }
    }
    toks.push(keys[p]);
    p++;
  }
  const groups = [];
  let count = "";
  let inInsert = false;
  let i = 0;
  while (i < toks.length) {
    const t = toks[i++];
    if (inInsert) { if (t === "<Esc>") inInsert = false; continue; }
    if (t.length === 1 && t >= "1" && t <= "9") { count += t; continue; }
    if (t === "i" || t === "a" || t === "I" || t === "A" || t === "o" ||
        t === "O" || t === "R" || t === "s" || t === "S" || t === "C") {
      groups.push(count + t); count = ""; inInsert = true; continue;
    }
    if ((t === "f" || t === "t" || t === "F" || t === "T" || t === "r") && t.length === 1) {
      const ch = i < toks.length ? toks[i++] : "";
      groups.push(count + t + ch); count = ""; continue;
    }
    if (t === "g") {
      const nxt = i < toks.length ? toks[i++] : "";
      groups.push(count + t + nxt); count = ""; continue;
    }
    if (t === '"' || t === "q" || t === "@") {
      const reg = i < toks.length ? toks[i++] : "";
      groups.push(count + t + reg); count = ""; continue;
    }
    if (t === "/" || t === "?" || t === ":") {
      while (i < toks.length && toks[i] !== "<CR>") i++;
      if (i < toks.length) i++;
      groups.push(count + t + "..."); count = ""; continue;
    }
    groups.push(count + t); count = "";
  }
  return groups;
}

function showTokenHint(ex) {
  const hint = document.getElementById("token-hint-" + ex.id);
  if (!hint) return;
  const list = keysToHintList(ex.keys);
  const joined = list.length <= 1 ? (list[0] || ex.keys)
    : LANG === "es"
      ? list.slice(0, -1).join(", ") + " y " + list[list.length - 1]
      : list.slice(0, -1).join(", ") + " and " + list[list.length - 1];
  const msgEs = "Llegaste al resultado, pero el ejercicio pide usar "
    + joined + ". Reinicia e inténtalo con esas teclas.";
  const msgEn = "You reached the goal, but this exercise asks you to use "
    + joined + ". Reset and try with those keys.";
  hint.textContent = LANG === "es" ? msgEs : msgEn;
  hint.style.display = "block";
}

function clearTokenHint(exId) {
  const hint = document.getElementById("token-hint-" + exId);
  if (hint) hint.style.display = "none";
}

// ---------------------------------------------------------------------------
// Bootstrap
// ---------------------------------------------------------------------------

async function main() {
  loadPrefs();
  applyLang();
  renderSkeletonHeader();

  try {
    const res = await fetch("./exercises.json");
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    DATA = await res.json();
  } catch (err) {
    document.querySelector(".main-content").innerHTML =
      `<div class="empty-state">Error al cargar ejercicios: ${err.message}</div>`;
    return;
  }

  renderSidebar();
  renderProgressBar();

  // #lesson-N opens that lesson (links from the slides); otherwise lesson 1.
  const fromHash = () => DATA.lessons.find(l => `#${l.id}` === location.hash);
  showLesson((fromHash() || DATA.lessons[0]).id);
  window.addEventListener("hashchange", () => {
    const lesson = fromHash();
    if (lesson) showLesson(lesson.id);
  });
}

// ---------------------------------------------------------------------------
// Prefs persistence
// ---------------------------------------------------------------------------

function loadPrefs() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) PROGRESS = new Set(JSON.parse(raw));
  } catch (_) {}
  try {
    const l = localStorage.getItem(LANG_KEY);
    if (l === "en" || l === "es") LANG = l;
  } catch (_) {}
}

function saveProgress() {
  try { localStorage.setItem(STORAGE_KEY, JSON.stringify([...PROGRESS])); } catch (_) {}
}

function saveLang() {
  try { localStorage.setItem(LANG_KEY, LANG); } catch (_) {}
}

// ---------------------------------------------------------------------------
// i18n helper
// ---------------------------------------------------------------------------

function t(obj, esKey, enKey) {
  if (LANG === "en" && obj[enKey]) return obj[enKey];
  return obj[esKey] || obj[enKey] || "";
}

function applyLang() {
  document.documentElement.setAttribute("data-lang", LANG);
  document.querySelectorAll("[data-es]").forEach(el => {
    el.textContent = LANG === "es" ? el.dataset.es : (el.dataset.en || el.dataset.es);
  });
  const btn = document.getElementById("btn-lang");
  if (btn) btn.textContent = LANG === "es" ? "EN" : "ES";
}

function toggleLang() {
  LANG = LANG === "es" ? "en" : "es";
  saveLang();
  // Re-render everything
  applyLang();
  renderSidebar();
  // Re-render the open lesson with fresh editors: keeping the old editor map
  // while the DOM is rebuilt left every exercise without an editor.
  if (CURRENT_LESSON) showLesson(CURRENT_LESSON, true);
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

function renderSkeletonHeader() {
  const header = document.querySelector(".app-header");
  if (!header) return;
  header.innerHTML = `
    <span class="header-pill">Vim</span>
    <h1 data-es="Práctica interactiva" data-en="Interactive Practice">Práctica interactiva</h1>
    <div class="header-links">
      <a href="https://github.com/chochy2001/Neovim-Vim_Configuration" target="_blank" rel="noopener">GitHub</a>
      <button class="btn-lang" id="btn-lang" aria-label="Switch language">${LANG === "es" ? "EN" : "ES"}</button>
    </div>
  `;
  document.getElementById("btn-lang").addEventListener("click", toggleLang);
}

// ---------------------------------------------------------------------------
// Sidebar
// ---------------------------------------------------------------------------

function renderSidebar() {
  if (!DATA) return;
  const sidebar = document.querySelector(".sidebar");
  if (!sidebar) return;
  sidebar.innerHTML = "";

  const header = document.createElement("div");
  header.className = "sidebar-section";
  header.setAttribute("data-es", "Lecciones");
  header.setAttribute("data-en", "Lessons");
  header.textContent = LANG === "es" ? "Lecciones" : "Lessons";
  sidebar.appendChild(header);

  DATA.lessons.forEach(lesson => {
    const exercises = lesson.exercises || [];
    const wrap = document.createElement("div");
    wrap.className = "sidebar-lesson";
    wrap.setAttribute("data-lesson-id", lesson.id);

    // A button, so every lesson opens from the sidebar (reference-only
    // lessons have no exercise buttons) and works from the keyboard.
    const title = document.createElement("button");
    title.type = "button";
    title.className = "sidebar-lesson-title" + (lesson.locked ? " locked" : "");
    title.dataset.lessonId = lesson.id;
    if (lesson.locked) {
      const lockIcon = document.createElement("span");
      lockIcon.className = "sidebar-lock-icon";
      lockIcon.setAttribute("aria-hidden", "true");
      lockIcon.textContent = "🔒";
      title.appendChild(lockIcon);
      const titleText = document.createElement("span");
      titleText.textContent = t(lesson, "titleEs", "titleEn");
      title.appendChild(titleText);
    } else {
      title.textContent = t(lesson, "titleEs", "titleEn");
    }
    title.addEventListener("click", () => {
      showLesson(lesson.id);
      window.scrollTo({ top: 0 });
      document.querySelector(".main-content")?.scrollTo?.({ top: 0 });
    });
    wrap.appendChild(title);

    if (lesson.locked) {
      const lockNote = document.createElement("div");
      lockNote.className = "sidebar-ref-note sidebar-locked-note";
      const count = lesson.exercise_count || 0;
      lockNote.setAttribute("data-es", count + " ejercicios");
      lockNote.setAttribute("data-en", count + " exercises");
      lockNote.textContent = LANG === "es" ? count + " ejercicios" : count + " exercises";
      wrap.appendChild(lockNote);
    } else if (exercises.length === 0) {
      const note = document.createElement("div");
      note.className = "sidebar-ref-note";
      note.setAttribute("data-es", "Solo referencia");
      note.setAttribute("data-en", "Reference only");
      note.textContent = LANG === "es" ? "Solo referencia" : "Reference only";
      wrap.appendChild(note);
    } else {
      exercises.forEach((ex, i) => {
        const btn = document.createElement("button");
        btn.className = "sidebar-ex-btn" + (PROGRESS.has(ex.id) ? " done" : "");
        btn.dataset.exId = ex.id;
        btn.dataset.lessonId = lesson.id;
        btn.setAttribute("aria-label", t(ex, "titleEs", "titleEn"));

        const check = document.createElement("span");
        check.className = "ex-check";
        check.setAttribute("aria-hidden", "true");
        check.textContent = PROGRESS.has(ex.id) ? "✓" : "○";

        const label = document.createElement("span");
        label.textContent = t(ex, "titleEs", "titleEn");

        btn.appendChild(check);
        btn.appendChild(label);
        btn.addEventListener("click", () => {
          showLesson(lesson.id);
          scrollToExercise(ex.id);
        });
        wrap.appendChild(btn);
      });
    }

    sidebar.appendChild(wrap);
  });
}

function setSidebarActive(exId) {
  document.querySelectorAll(".sidebar-ex-btn").forEach(btn => {
    btn.classList.toggle("active", btn.dataset.exId === exId);
  });
}

function setSidebarDone(exId) {
  document.querySelectorAll(`.sidebar-ex-btn[data-ex-id="${exId}"]`).forEach(btn => {
    btn.classList.add("done");
    const check = btn.querySelector(".ex-check");
    if (check) check.textContent = "✓";
  });
}

// ---------------------------------------------------------------------------
// Progress bar
// ---------------------------------------------------------------------------

function renderProgressBar() {
  const wrap = document.querySelector(".progress-bar-wrap");
  if (!wrap || !DATA) return;
  const total = DATA.lessons.reduce((s, l) => l.locked ? s : s + (l.exercises || []).length, 0);
  const done = [...PROGRESS].filter(id => {
    return DATA.lessons.some(l => !l.locked && (l.exercises || []).some(e => e.id === id));
  }).length;
  const pct = total > 0 ? Math.round((done / total) * 100) : 0;
  wrap.setAttribute("role", "progressbar");
  wrap.setAttribute("aria-label", LANG === "es" ? "Progreso del curso" : "Course progress");
  wrap.setAttribute("aria-valuenow", String(done));
  wrap.setAttribute("aria-valuemin", "0");
  wrap.setAttribute("aria-valuemax", String(total));
  wrap.innerHTML = `<div class="progress-bar-fill" style="width:${pct}%" title="${done}/${total}" aria-hidden="true"></div>`;
}

// ---------------------------------------------------------------------------
// Lesson view
// ---------------------------------------------------------------------------

function showLesson(lessonId, destroyEditors = true) {
  if (destroyEditors) {
    editors.forEach(({ view }) => view.destroy());
    editors.clear();
  }

  const lesson = DATA.lessons.find(l => l.id === lessonId);
  if (!lesson) return;
  CURRENT_LESSON = lesson.id;

  const main = document.querySelector(".main-content");
  if (!main) return;

  main.innerHTML = "";
  // The progress bar lives at the top of the lesson; rebuilding the lesson
  // used to delete it for good.
  const progress = document.createElement("div");
  progress.className = "progress-bar-wrap";
  progress.id = "progress-bar-wrap";
  main.appendChild(progress);
  renderProgressBar();

  // Keep the URL in sync so slides can link straight to a lesson.
  if (location.hash !== `#${lesson.id}`) window.history.replaceState(null, "", `#${lesson.id}`); // "history" is CodeMirror's undo import

  // Locked lesson: show CTA card and stop.
  if (lesson.locked) {
    renderLockedLesson(lesson, main);
    return;
  }

  // Header
  const header = document.createElement("div");
  header.className = "lesson-header";
  const h2 = document.createElement("h2");
  h2.textContent = t(lesson, "titleEs", "titleEn");
  const desc = document.createElement("p");
  desc.className = "lesson-desc";
  desc.textContent = t(lesson, "descriptionEs", "descriptionEn");
  header.appendChild(h2);
  if (lesson.descriptionEs || lesson.descriptionEn) header.appendChild(desc);
  main.appendChild(header);

  const exercises = lesson.exercises || [];

  if (exercises.length === 0) {
    // Reference-only section
    renderRefSection(lesson, main);
    return;
  }
  // A lesson can also carry reference text (lesson 1: save and quit).
  if (REFERENCE_CONTENT[lesson.id]) renderRefSection(lesson, main, true);

  exercises.forEach((ex, i) => {
    const card = buildExerciseCard(ex, i, exercises.length);
    main.appendChild(card);
    // Lazily initialize the editor on first intersection
    scheduleEditor(ex);
  });
}

function renderLockedLesson(lesson, container) {
  const academyUrl = (DATA && DATA.academy_url) || "https://academy.capdesis.com";
  const count = lesson.exercise_count || 0;
  const titleText = t(lesson, "titleEs", "titleEn");

  const cta = document.createElement("div");
  cta.className = "locked-lesson-cta";
  cta.setAttribute("data-lesson-id", lesson.id);

  const icon = document.createElement("div");
  icon.className = "locked-cta-icon";
  icon.setAttribute("aria-hidden", "true");
  icon.textContent = "🔒";

  const h2 = document.createElement("h2");
  h2.className = "locked-cta-title";
  h2.textContent = titleText;

  const body = document.createElement("p");
  body.className = "locked-cta-body";
  if (LANG === "es") {
    body.textContent = "Esta lección está en Capdesis Academy. Es gratis: crea tu cuenta y continúa con "
      + count + " ejercicio" + (count !== 1 ? "s" : "") + ".";
  } else {
    body.textContent = "This lesson is on Capdesis Academy. It is free: create your account and continue with "
      + count + " exercise" + (count !== 1 ? "s" : "") + ".";
  }

  const link = document.createElement("a");
  link.className = "btn btn-academy";
  link.href = academyUrl;
  link.target = "_blank";
  link.rel = "noopener";
  link.setAttribute("data-es", "Ir a Capdesis Academy");
  link.setAttribute("data-en", "Go to Capdesis Academy");
  link.textContent = LANG === "es" ? "Ir a Capdesis Academy" : "Go to Capdesis Academy";

  cta.appendChild(icon);
  cta.appendChild(h2);
  cta.appendChild(body);
  cta.appendChild(link);
  container.appendChild(cta);
}

function scrollToExercise(exId) {
  // Create the editor now: the lazy observer only fires once the card is on
  // screen, and the last card of a long lesson could stay below it.
  const exercise = DATA.lessons.flatMap(l => l.exercises || []).find(e => e.id === exId);
  if (exercise) initEditor(exercise);
  const card = document.querySelector(`[data-exercise-id="${exId}"]`);
  if (card) card.scrollIntoView({ block: "start" });
  setSidebarActive(exId);
  // initEditor registers the view on the next tick
  setTimeout(() => {
    const info = editors.get(exId);
    if (info) info.view.focus();
  }, 0);
}

// ---------------------------------------------------------------------------
// Reference section rendering
// ---------------------------------------------------------------------------

const REFERENCE_CONTENT = {
  "lesson-5": {
    es: {
      title: "Buscar y sustituir",
      body: `Vim tiene un motor de búsqueda y sustitución integrado en la línea de comandos.

Búsqueda: escribe <code>/patrón</code> y Enter para buscar hacia adelante, <code>?patrón</code> hacia atrás. Repite con <code>n</code> (siguiente) y <code>N</code> (anterior). <code>*</code> busca la palabra bajo el cursor.

Sustitución: <code>:s/viejo/nuevo/</code> cambia la primera ocurrencia en la línea. <code>:s/viejo/nuevo/g</code> cambia todas. <code>:%s/viejo/nuevo/g</code> cambia en todo el archivo. Añade la bandera <code>c</code> para confirmar cada cambio.

Estos comandos no se pueden emular fielmente en el navegador, por lo que esta lección es de referencia.`,
    },
    en: {
      title: "Search and replace",
      body: `Vim has a built-in search and replace engine accessible from the command line.

Search: type <code>/pattern</code> and Enter to search forward, <code>?pattern</code> backward. Repeat with <code>n</code> (next) and <code>N</code> (previous). <code>*</code> searches the word under the cursor.

Substitute: <code>:s/old/new/</code> replaces the first occurrence on the line. <code>:s/old/new/g</code> replaces all. <code>:%s/old/new/g</code> replaces across the whole file. Add the <code>c</code> flag to confirm each change.

These commands cannot be reliably emulated in the browser, so this lesson is reference-only.`,
    },
  },
  "lesson-7": {
    es: {
      title: "Buffers, ventanas, pestañas y terminales",
      body: `Vim puede tener varios archivos abiertos en memoria al mismo tiempo.

<b>Buffers:</b> <code>:e archivo</code> abre un archivo. <code>:ls</code> lista los buffers. <code>:bn</code> va al siguiente, <code>:bp</code> al anterior. <code>:bd</code> cierra el buffer actual.

<b>Ventanas (splits):</b> <code>:sp</code> divide horizontalmente, <code>:vsp</code> verticalmente. Muévete entre ventanas con <code>Ctrl-w h/j/k/l</code>. Cierra con <code>:q</code> o <code>Ctrl-w q</code>.

<b>Pestañas:</b> <code>:tabnew</code> abre una nueva pestaña. <code>gt</code> va a la siguiente, <code>gT</code> a la anterior. <code>:tabclose</code> cierra la actual.

<b>Terminales (esta configuración):</b> <code>&lt;leader&gt;tv</code> abre una terminal a la derecha y <code>&lt;leader&gt;th</code> abajo; con un número delante abres otra (<code>2&lt;leader&gt;th</code>). <code>jj</code> vuelve a modo Normal dentro de la terminal y <code>Ctrl-h/j/k/l</code> cambia de ventana. <code>&lt;leader&gt;ta</code> las oculta o muestra sin cerrar los procesos y <code>&lt;leader&gt;tl</code> elige una.`,
    },
    en: {
      title: "Buffers, windows, tabs and terminals",
      body: `Vim can keep several files open in memory at the same time.

<b>Buffers:</b> <code>:e file</code> opens a file. <code>:ls</code> lists buffers. <code>:bn</code> goes to the next, <code>:bp</code> to the previous. <code>:bd</code> closes the current buffer.

<b>Windows (splits):</b> <code>:sp</code> splits horizontally, <code>:vsp</code> vertically. Move between windows with <code>Ctrl-w h/j/k/l</code>. Close with <code>:q</code> or <code>Ctrl-w q</code>.

<b>Tabs:</b> <code>:tabnew</code> opens a new tab. <code>gt</code> goes to the next, <code>gT</code> to the previous. <code>:tabclose</code> closes the current one.

<b>Terminals (this configuration):</b> <code>&lt;leader&gt;tv</code> opens a terminal on the right and <code>&lt;leader&gt;th</code> at the bottom; a number in front opens another one (<code>2&lt;leader&gt;th</code>). <code>jj</code> goes back to Normal mode inside the terminal and <code>Ctrl-h/j/k/l</code> switches windows. <code>&lt;leader&gt;ta</code> hides or shows them without stopping their processes and <code>&lt;leader&gt;tl</code> picks one.`,
    },
  },
  "lesson-6": {
    es: {
      title: "Registros y macros",
      body: `Vim permite guardar texto en registros y grabar secuencias de teclas.

<b>Registros:</b> cada registro es un slot identificado por una letra (<code>"a</code> a <code>"z</code>). Yank a un registro: <code>"ayy</code> copia la línea al registro <code>a</code>. Pegar desde él: <code>"ap</code>. El registro <code>"+</code> es el portapapeles del sistema.

<b>Macros:</b> <code>qa</code> empieza a grabar en el registro <code>a</code>. Haz los cambios. <code>q</code> detiene la grabación. <code>@a</code> reproduce la macro. <code>@@</code> repite la última. <code>5@a</code> la repite 5 veces.

<b>Truco:</b> pega la macro con <code>"ap</code>, edítala, ve al inicio de la línea con <code>0</code> y guárdala de nuevo con <code>"ay$</code>.`,
    },
    en: {
      title: "Registers and macros",
      body: `Vim lets you save text in registers and record key sequences.

<b>Registers:</b> each register is a named slot from <code>"a</code> to <code>"z</code>. Yank to a register: <code>"ayy</code> copies the line to register <code>a</code>. Paste from it: <code>"ap</code>. Register <code>"+</code> is the system clipboard.

<b>Macros:</b> <code>qa</code> starts recording into register <code>a</code>. Make your changes. <code>q</code> stops recording. <code>@a</code> replays the macro. <code>@@</code> repeats the last one. <code>5@a</code> repeats it 5 times.

<b>Tip:</b> paste the macro with <code>"ap</code>, edit it, go to the start of the line with <code>0</code> and save it back with <code>"ay$</code>.`,
    },
  },
  "lesson-8": {
    es: {
      title: "Tu configuración",
      body: `Ya dominas Vim sin plugins. Ahora pasa a la configuración real de este curso: instálala siguiendo el README (Windows, macOS o Linux) y pon una Nerd Font en tu terminal.

La tecla líder es <b>Espacio</b>: <code>&lt;leader&gt;ff</code> significa Espacio, f, f. Pulsa Espacio y espera un momento: aparece un menú con todos los grupos de atajos.

Abajo tienes todos los atajos de la configuración, sacados de WORKFLOW.md. Búscalos por nombre o por tecla.`,
    },
    en: {
      title: "Your configuration",
      body: `You now know Vim without plugins. Move on to this course's real configuration: install it following the README (Windows, macOS or Linux) and set a Nerd Font in your terminal.

The leader key is <b>Space</b>: <code>&lt;leader&gt;ff</code> means Space, f, f. Press Space and wait a moment: a menu shows every group of shortcuts.

Below are all the shortcuts of the configuration, taken from WORKFLOW.md. Search them by name or key.`,
    },
  },
  "lesson-1": {
    es: {
      title: "Ayuda, guardar y salir",
      body: `Los comandos esenciales para el día a día.

<b>Ayuda:</b> <code>:h tópico</code> abre la documentación de Vim. <code>Ctrl-]</code> sigue un enlace, <code>Ctrl-o</code> vuelve atrás. Cierra la ventana de ayuda con <code>:q</code>.

<b>Guardar y salir:</b> <code>:w</code> guarda. <code>:q</code> sale si no hay cambios pendientes. <code>:wq</code> guarda y sale (siempre escribe). <code>ZZ</code> guarda y sale solo si hay cambios (igual que <code>:x</code>). <code>:q!</code> o <code>ZQ</code> sale descartando cambios. <code>:wqa</code> guarda todos los buffers y sale de Vim.

<b>Deshacer/Rehacer:</b> <code>u</code> deshace, <code>Ctrl-r</code> rehace. Vim mantiene un árbol de cambios: <code>:earlier 5m</code> vuelve al estado de hace 5 minutos.`,
    },
    en: {
      title: "Help, save and quit",
      body: `The essential commands for everyday use.

<b>Help:</b> <code>:h topic</code> opens Vim's documentation. <code>Ctrl-]</code> follows a link, <code>Ctrl-o</code> goes back. Close the help window with <code>:q</code>.

<b>Save and quit:</b> <code>:w</code> saves. <code>:q</code> quits if there are no pending changes. <code>:wq</code> saves and quits (always writes). <code>ZZ</code> saves and quits only if the buffer was modified (same as <code>:x</code>). <code>:q!</code> or <code>ZQ</code> quits discarding changes. <code>:wqa</code> saves every buffer and quits Vim.

<b>Undo/Redo:</b> <code>u</code> undoes, <code>Ctrl-r</code> redoes. Vim keeps a change tree: <code>:earlier 5m</code> returns the state from 5 minutes ago.`,
    },
  },
};

// Key shortcut groups from WORKFLOW.md

function renderRefSection(lesson, container, beforeExercises = false) {
  const content = REFERENCE_CONTENT[lesson.id];
  if (!content) {
    const sec = document.createElement("div");
    sec.className = "ref-section";
    sec.innerHTML = `<p>${LANG === "es" ? "Esta lección es de referencia en el curso impreso." : "This lesson is reference-only in the printed course."}</p>`;
    container.appendChild(sec);
    return;
  }

  const data = LANG === "en" ? content.en : content.es;
  const sec = document.createElement("div");
  sec.className = "ref-section";
  sec.innerHTML = `
    <h2>${data.title}</h2>
    <p>${data.body.replace(/\n\n/g, '</p><p>')}</p>
    <p class="ref-note">${beforeExercises
      ? (LANG === "es"
        ? "Estas órdenes se usan en Neovim. Los ejercicios de abajo practican los modos en el navegador."
        : "These commands are used in Neovim. The exercises below practise the modes in the browser.")
      : lesson.id === "lesson-8"
      ? (LANG === "es"
        ? "Estos atajos existen en la configuración real: instálala (README) y pruébalos en Neovim."
        : "These shortcuts exist in the real configuration: install it (README) and try them in Neovim.")
      : (LANG === "es"
        ? "Practica esta lección en Neovim: el navegador no reproduce con fidelidad la línea de comandos (:), los registros, las ventanas ni los buffers."
        : "Practise this lesson in Neovim: the browser cannot faithfully reproduce the command line (:), registers, windows or buffers.")}</p>
  `;
  container.appendChild(sec);

  // The whole cheat sheet closes the route, in "Your configuration".
  if (lesson.id === "lesson-8") {
    renderCheatsheet(container);
  }
}

function renderCheatsheet(container) {
  const wrap = document.createElement("div");
  wrap.className = "ref-section cheatsheet";

  const title = document.createElement("h2");
  title.textContent = LANG === "es" ? "Atajos de tu configuración" : "Your config shortcuts";
  wrap.appendChild(title);

  const search = document.createElement("input");
  search.type = "text";
  search.className = "cheatsheet-search";
  search.placeholder = LANG === "es" ? "Buscar atajo..." : "Search shortcut...";
  wrap.appendChild(search);

  const groups = document.createElement("div");
  groups.id = "cheatsheet-groups";
  // Generated from WORKFLOW.md by build_practice.py (descriptions in English);
  // tests/integration.lua checks every key exists in the Neovim config.
  (DATA.shortcuts || []).forEach(g => {
    const div = document.createElement("div");
    div.className = "cheatsheet-group";
    const h3 = document.createElement("h3");
    h3.textContent = g.title;
    div.appendChild(h3);
    g.rows.forEach(r => {
      const row = document.createElement("div");
      row.className = "shortcut-row";
      const k = document.createElement("kbd");
      k.textContent = r.key;
      const m = document.createElement("span");
      m.className = "shortcut-mode";
      m.textContent = r.mode;
      const d = document.createElement("span");
      d.className = "shortcut-desc";
      d.textContent = r.desc;
      row.appendChild(k);
      row.appendChild(m);
      row.appendChild(d);
      div.appendChild(row);
    });
    groups.appendChild(div);
  });
  wrap.appendChild(groups);

  const note = document.createElement("p");
  note.className = "cheatsheet-note";
  note.textContent = LANG === "es"
    ? "Todos los atajos de WORKFLOW.md (descripciones en inglés). Tecla líder: Espacio."
    : "Every shortcut from WORKFLOW.md. Leader key: Space.";
  wrap.appendChild(note);

  // Filter on search
  search.addEventListener("input", () => {
    const q = search.value.toLowerCase();
    wrap.querySelectorAll(".shortcut-row").forEach(row => {
      const text = row.textContent.toLowerCase();
      row.style.display = !q || text.includes(q) ? "" : "none";
    });
    wrap.querySelectorAll(".cheatsheet-group").forEach(g => {
      const anyVisible = [...g.querySelectorAll(".shortcut-row")].some(r => r.style.display !== "none");
      g.style.display = anyVisible ? "" : "none";
    });
  });

  container.appendChild(wrap);
}

// ---------------------------------------------------------------------------
// Exercise card
// ---------------------------------------------------------------------------

function buildExerciseCard(ex, index, total) {
  const card = document.createElement("div");
  card.className = "exercise-card";
  card.setAttribute("data-exercise-id", ex.id);

  // --- Header ---
  const exHeader = document.createElement("div");
  exHeader.className = "ex-header";
  const num = document.createElement("span");
  num.className = "ex-num";
  num.textContent = `${index + 1}/${total}`;
  const title = document.createElement("h3");
  title.className = "ex-title";
  title.id = `ex-title-${ex.id}`;
  title.textContent = t(ex, "titleEs", "titleEn");
  exHeader.appendChild(num);
  exHeader.appendChild(title);
  card.appendChild(exHeader);

  // --- Hint ---
  const hint = document.createElement("p");
  hint.className = "ex-hint";
  hint.textContent = t(ex, "hintEs", "hintEn");
  card.appendChild(hint);

  // --- Diff view ---
  const diffWrap = document.createElement("div");
  diffWrap.className = "diff-wrap";

  const startPanel = document.createElement("div");
  startPanel.className = "diff-panel start";
  const startLabel = document.createElement("div");
  startLabel.className = "diff-label";
  startLabel.setAttribute("data-es", "Inicio");
  startLabel.setAttribute("data-en", "Start");
  startLabel.textContent = LANG === "es" ? "Inicio" : "Start";
  const startCode = document.createElement("pre");
  startCode.className = "diff-code";
  showWithCursor(startCode, ex.start, ex.startRow, ex.startCol);
  startPanel.appendChild(startLabel);
  startPanel.appendChild(startCode);

  const goalPanel = document.createElement("div");
  goalPanel.className = "diff-panel goal";
  const goalLabel = document.createElement("div");
  goalLabel.className = "diff-label";
  goalLabel.setAttribute("data-es", "Meta");
  goalLabel.setAttribute("data-en", "Goal");
  goalLabel.textContent = LANG === "es" ? "Meta" : "Goal";
  const goalCode = document.createElement("pre");
  goalCode.className = "diff-code";
  // Show where the cursor must end: movement exercises have equal texts.
  if (ex.checkCursor === false) goalCode.textContent = ex.expectedText;
  else showWithCursor(goalCode, ex.expectedText, ex.expectedRow, ex.expectedCol);
  goalPanel.appendChild(goalLabel);
  goalPanel.appendChild(goalCode);

  diffWrap.appendChild(startPanel);
  diffWrap.appendChild(goalPanel);
  card.appendChild(diffWrap);

  // --- Editor wrapper (placeholder, filled by scheduleEditor) ---
  const editorOuter = document.createElement("div");
  editorOuter.className = "editor-wrap";
  editorOuter.id = `editor-${ex.id}`;
  editorOuter.setAttribute("aria-labelledby", `ex-title-${ex.id}`);

  const modeBar = document.createElement("div");
  modeBar.className = "mode-bar";
  modeBar.id = `mode-${ex.id}`;
  modeBar.setAttribute("aria-label", LANG === "es" ? "Modo Vim" : "Vim mode");
  const modePill = document.createElement("span");
  modePill.className = "mode-pill normal";
  modePill.setAttribute("aria-live", "polite");
  modePill.textContent = LANG === "es" ? "NORMAL" : "NORMAL";
  const cursorPos = document.createElement("span");
  cursorPos.className = "cursor-pos";
  cursorPos.setAttribute("aria-hidden", "true");
  cursorPos.textContent = "1:1";
  modeBar.appendChild(modePill);
  modeBar.appendChild(cursorPos);

  const editorMount = document.createElement("div");
  editorMount.id = `cm-${ex.id}`;

  editorOuter.appendChild(modeBar);
  editorOuter.appendChild(editorMount);
  card.appendChild(editorOuter);

  // --- Controls ---
  const controls = document.createElement("div");
  controls.className = "ex-controls";

  const btnReset = document.createElement("button");
  btnReset.className = "btn btn-secondary";
  btnReset.setAttribute("data-es", "Reiniciar");
  btnReset.setAttribute("data-en", "Reset");
  btnReset.textContent = LANG === "es" ? "Reiniciar" : "Reset";
  btnReset.addEventListener("click", () => resetExercise(ex));

  const btnSolve = document.createElement("button");
  btnSolve.className = "btn btn-secondary";
  btnSolve.setAttribute("data-es", "Ver solución");
  btnSolve.setAttribute("data-en", "Show solution");
  btnSolve.setAttribute("aria-expanded", "false");
  btnSolve.setAttribute("aria-controls", `sol-${ex.id}`);
  btnSolve.textContent = LANG === "es" ? "Ver solución" : "Show solution";
  btnSolve.addEventListener("click", () => toggleSolution(ex, card));

  controls.appendChild(btnReset);
  controls.appendChild(btnSolve);
  card.appendChild(controls);

  // --- Solution box (hidden by default) ---
  const solBox = document.createElement("div");
  solBox.className = "solution-box";
  solBox.id = `sol-${ex.id}`;
  solBox.style.display = "none";
  const solLabel = document.createElement("div");
  solLabel.className = "sol-label";
  solLabel.setAttribute("data-es", "Solución: teclas a pulsar");
  solLabel.setAttribute("data-en", "Solution: keys to press");
  solLabel.textContent = LANG === "es" ? "Solución: teclas a pulsar" : "Solution: keys to press";
  const keySeq = document.createElement("div");
  keySeq.className = "key-seq";
  keySeq.innerHTML = renderKeySequence(ex.keys);
  solBox.appendChild(solLabel);
  solBox.appendChild(keySeq);
  card.appendChild(solBox);

  // --- Success message ---
  // Find the next unsolved exercise in this lesson (for the "Next" button).
  const lesson = DATA.lessons.find(l => (l.exercises || []).some(e => e.id === ex.id));
  const lessonExercises = lesson ? (lesson.exercises || []) : [];
  const nextEx = lessonExercises[index + 1] || null;

  const successMsg = document.createElement("div");
  successMsg.className = "success-msg";
  successMsg.id = `ok-${ex.id}`;
  successMsg.setAttribute("role", "status");
  successMsg.setAttribute("aria-atomic", "true");
  successMsg.style.display = PROGRESS.has(ex.id) ? "flex" : "none";

  const successIcon = document.createElement("span");
  successIcon.className = "success-icon";
  successIcon.setAttribute("aria-hidden", "true");
  successIcon.textContent = "✓";

  const successText = document.createElement("span");
  successText.setAttribute("data-es", nextEx
    ? "Correcto. Pasa al siguiente ejercicio."
    : "Correcto. Lección completada.");
  successText.setAttribute("data-en", nextEx
    ? "Correct. Move to the next exercise."
    : "Correct. Lesson complete.");
  successText.textContent = LANG === "es"
    ? (nextEx ? "Correcto. Pasa al siguiente ejercicio." : "Correcto. Lección completada.")
    : (nextEx ? "Correct. Move to the next exercise." : "Correct. Lesson complete.");

  successMsg.appendChild(successIcon);
  successMsg.appendChild(successText);

  if (nextEx) {
    const btnNext = document.createElement("button");
    btnNext.className = "btn btn-next";
    btnNext.setAttribute("data-es", "Siguiente ejercicio");
    btnNext.setAttribute("data-en", "Next exercise");
    btnNext.textContent = LANG === "es" ? "Siguiente ejercicio" : "Next exercise";
    btnNext.addEventListener("click", () => scrollToExercise(nextEx.id));
    successMsg.appendChild(btnNext);
  }

  card.appendChild(successMsg);

  // --- Token hint (shown when state matches but required keys were not used) ---
  const tokenHint = document.createElement("div");
  tokenHint.className = "token-hint";
  tokenHint.id = `token-hint-${ex.id}`;
  tokenHint.setAttribute("role", "status");
  tokenHint.setAttribute("aria-live", "polite");
  tokenHint.setAttribute("aria-atomic", "true");
  tokenHint.style.display = "none";
  card.appendChild(tokenHint);

  return card;
}

// ---------------------------------------------------------------------------
// Key sequence formatter
// ---------------------------------------------------------------------------

const SPECIAL_KEY_MAP = {
  "<Esc>": "Esc",
  "<CR>": "Enter",
  "<Space>": "Space",
  "<Tab>": "Tab",
  "<BS>": "Backspace",
  "<C-r>": "Ctrl+r",
  "<C-o>": "Ctrl+o",
  "<C-v>": "Ctrl+v",
};

// Render text with the character under the cursor highlighted, like Vim's
// block cursor. An empty line or end of line shows a highlighted space.
function showWithCursor(pre, text, row, col) {
  pre.textContent = "";
  const lines = text.split("\n");
  lines.forEach((line, i) => {
    if (i > 0) pre.appendChild(document.createTextNode("\n"));
    if (i !== row) {
      pre.appendChild(document.createTextNode(line));
      return;
    }
    const chars = Array.from(line);
    pre.appendChild(document.createTextNode(chars.slice(0, col).join("")));
    const mark = document.createElement("span");
    mark.className = "cursor-mark";
    mark.textContent = chars[col] || " ";
    pre.appendChild(mark);
    pre.appendChild(document.createTextNode(chars.slice(col + 1).join("")));
  });
}

function renderKeySequence(keys) {
  // Split the keys string into individual tokens
  const tokens = [];
  let i = 0;
  while (i < keys.length) {
    if (keys[i] === "<") {
      const end = keys.indexOf(">", i);
      if (end !== -1) {
        tokens.push(keys.slice(i, end + 1));
        i = end + 1;
        continue;
      }
    }
    tokens.push(keys[i]);
    i++;
  }

  return tokens.map(tok => {
    const label = SPECIAL_KEY_MAP[tok] || tok;
    const isSpecial = tok.startsWith("<");
    return `<kbd class="${isSpecial ? "special" : ""}">${escapeHtml(label)}</kbd>`;
  }).join(" ");
}

function escapeHtml(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

// ---------------------------------------------------------------------------
// Lazy editor initialization
// ---------------------------------------------------------------------------

let editorObserver = null;

function scheduleEditor(ex) {
  if (!editorObserver) {
    editorObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const el = entry.target;
          const exId = el.dataset.lazyExId;
          editorObserver.unobserve(el);
          delete el.dataset.lazyExId;
          const exercise = DATA.lessons
            .flatMap(l => l.exercises || [])
            .find(e => e.id === exId);
          if (exercise) initEditor(exercise);
        }
      });
    }, { rootMargin: "200px 0px" });
  }

  const mount = document.getElementById(`cm-${ex.id}`);
  if (mount) {
    mount.dataset.lazyExId = ex.id;
    editorObserver.observe(mount);
  }
}

// ---------------------------------------------------------------------------
// CodeMirror editor init
// ---------------------------------------------------------------------------

function isDarkTheme() {
  if (document.documentElement.dataset.theme === "dark") return true;
  if (document.documentElement.dataset.theme === "light") return false;
  return window.matchMedia("(prefers-color-scheme: dark)").matches;
}

function posFromRowCol(state, row, col) {
  const lineCount = state.doc.lines;
  const lineNum = Math.min(row + 1, lineCount);
  const line = state.doc.line(lineNum);
  return line.from + Math.min(col, line.length);
}

function rowColFromPos(state, pos) {
  const line = state.doc.lineAt(pos);
  return { row: line.number - 1, col: pos - line.from };
}

function initEditor(ex) {
  const mount = document.getElementById(`cm-${ex.id}`);
  // editors is filled on the next tick, so mark the mount now: the lazy
  // observer and a sidebar click must not both create an editor.
  if (!mount || editors.has(ex.id) || mount.dataset.ready) return;
  mount.dataset.ready = "1";
  if (editorObserver) editorObserver.unobserve(mount);

  const extensions = [
    vim(),
    history(),
    lineNumbers(),
    drawSelection(),
    highlightActiveLine(),
    highlightActiveLineGutter(),
    EditorView.lineWrapping,
    // Same as the Neovim config and tests/vim_reference.lua: shiftwidth=4,
    // expandtab. CodeMirror's default of 2 spaces made >> and << disagree.
    indentUnit.of("    "),
    EditorState.tabSize.of(4),
  ];

  if (isDarkTheme()) extensions.push(oneDark);

  // Update listener to check correctness after every transaction
  extensions.push(
    EditorView.updateListener.of(update => {
      if (update.docChanged) {
        const info = editors.get(ex.id);
        if (info) info.changed = true;
      }
      if (update.docChanged || update.selectionSet) {
        onEditorUpdate(ex, update.view);
      }
    })
  );

  const startPos = posFromRowCol(
    EditorState.create({ doc: ex.start }),
    ex.startRow,
    ex.startCol
  );

  const state = EditorState.create({
    doc: ex.start,
    selection: { anchor: startPos },
    extensions,
  });

  const view = new EditorView({ state, parent: mount });

  // Grab the CM5-compat adapter (set by codemirror-vim on the view instance)
  // Try after a tick to ensure vim extension has initialized
  setTimeout(() => {
    const cm = getCM(view);
    if (!cm) return;

    editors.set(ex.id, { view, cm, done: PROGRESS.has(ex.id), typedKeyStr: "" });

    // Track keys typed in this editor for token verification (Bug 1 fix).
    // We build a full vim-notation key string so that normalCommands() can
    // tokenize it the same way it tokenizes ex.keys -- handling counts (3gg),
    // text objects (iw), and insert-mode text correctly.
    // Use capture phase so we record keys before CodeMirror processes them.
    // Mouse events that move the cursor do NOT append tokens.
    view.dom.addEventListener("keydown", (e) => {
      // Skip synthetic events (macro playback, programmatic dispatch).
      if (!e.isTrusted) return;
      const info = editors.get(ex.id);
      if (!info || info.done) return;
      const tok = keyEventToVimToken(e);
      if (tok !== null) info.typedKeyStr += tok;
    }, { capture: true });

    // Mode change events
    cm.on("vim-mode-change", ({ mode }) => {
      updateModeBar(ex.id, mode);
      onEditorUpdate(ex, view);
    });

    // Initial mode bar state
    updateModeBar(ex.id, "normal");
    updateCursorPos(ex.id, ex.startRow, ex.startCol);

    // If already done, show the done state
    if (PROGRESS.has(ex.id)) {
      markEditorDone(ex.id);
    }
  }, 0);
}

// ---------------------------------------------------------------------------
// Mode bar
// ---------------------------------------------------------------------------

function updateModeBar(exId, mode) {
  const bar = document.getElementById(`mode-${exId}`);
  if (!bar) return;
  const pill = bar.querySelector(".mode-pill");
  if (!pill) return;
  pill.className = `mode-pill ${mode}`;
  const labels = {
    normal:  { es: "NORMAL",  en: "NORMAL"  },
    insert:  { es: "INSERTAR", en: "INSERT" },
    visual:  { es: "VISUAL",  en: "VISUAL"  },
    replace: { es: "REEMPLAZAR", en: "REPLACE" },
  };
  const lab = labels[mode] || labels.normal;
  pill.textContent = LANG === "es" ? lab.es : lab.en;
}

function updateCursorPos(exId, row, col) {
  const bar = document.getElementById(`mode-${exId}`);
  if (!bar) return;
  const span = bar.querySelector(".cursor-pos");
  if (span) span.textContent = `${row + 1}:${col + 1}`;
}

// ---------------------------------------------------------------------------
// Correctness check
// ---------------------------------------------------------------------------

function onEditorUpdate(ex, view) {
  const info = editors.get(ex.id);
  if (!info || info.done) return;

  const cm = info.cm || getCM(view);
  if (!cm) return;

  // Mode: must be normal (not insert, not visual)
  const vimState = cm.state.vim;
  // Normal mode with nothing pending: after `d`, `f`, `"a` or a count the
  // cursor may already sit on the goal, but the command is not finished.
  const input = (vimState && vimState.inputState) || {};
  const pending = Boolean(
    input.operator ||
      (input.keyBuffer || []).length ||
      (input.prefixRepeat || []).length ||
      (input.motionRepeat || []).length ||
      input.registerName
  );
  const isNormal = vimState && !vimState.insertMode && !vimState.visualMode && !pending;
  if (!isNormal) {
    updateCursorPos(ex.id, ...Object.values(rowColFromPos(view.state, view.state.selection.main.head)));
    return;
  }

  const text = view.state.doc.toString();
  const sel = view.state.selection.main;
  const { row, col } = rowColFromPos(view.state, sel.head);

  updateCursorPos(ex.id, row, col);

  if (
    text === ex.expectedText &&
    (ex.checkCursor === false || (row === ex.expectedRow && col === ex.expectedCol)) &&
    (!ex.requiresChange || info.changed)
  ) {
    // Token verification: the required command tokens must appear as an ordered
    // subsequence of the keys the learner actually typed.
    // Accept ex.keys, ex.alternatives, or ex.accepts (any match is enough).
    const keySets = [ex.keys];
    if (ex.alternatives) keySets.push(...(Array.isArray(ex.alternatives) ? ex.alternatives : [ex.alternatives]));
    if (ex.accepts) keySets.push(...(Array.isArray(ex.accepts) ? ex.accepts : [ex.accepts]));
    // Run normalCommands on the recorded key string so tokenization (counts,
    // text objects, insert-mode text) is handled the same on both sides.
    const typedToks = normalCommands(info.typedKeyStr || "");
    const tokenOk = keySets.some(ks => {
      if (!ks) return false;
      const required = normalCommands(ks);
      if (required.length === 0) return true;
      // Full match: required tokens appear as ordered subsequence of typed tokens.
      // Prefix match: typed tokens are a correct prefix of required tokens (handles
      // exercises where the goal state matches mid-sequence, e.g. macro exercises).
      // The prefix rule only applies to macro exercises (q... @...), where the
      // goal is reached mid-sequence; elsewhere every taught key is required.
      const isMacro = required.some(t => /^\d*@|^q/.test(t));
      return isSubsequence(required, typedToks) || (isMacro && isPrefixOf(required, typedToks));
    });
    if (!tokenOk) {
      // State is correct but the learner didn't use the required command.
      showTokenHint(ex);
      return;
    }
    clearTokenHint(ex.id);
    info.done = true;
    PROGRESS.add(ex.id);
    saveProgress();
    markDone(ex.id);
  }
}

function markDone(exId) {
  markEditorDone(exId);
  setSidebarDone(exId);
  renderProgressBar();
}

function markEditorDone(exId) {
  const outer = document.getElementById(`editor-${exId}`);
  if (outer) outer.classList.add("correct");

  const msg = document.getElementById(`ok-${exId}`);
  if (msg) {
    msg.style.display = "flex";
    // Animate only when newly solved (not on page load from localStorage).
    msg.classList.add("animate");
  }
}

// ---------------------------------------------------------------------------
// Reset exercise
// ---------------------------------------------------------------------------

function resetExercise(ex) {
  const info = editors.get(ex.id);
  if (!info) return;
  const { view } = info;

  const startPos = posFromRowCol(view.state, ex.startRow, ex.startCol);

  // Escape to normal mode first (via Vim API)
  const cm = info.cm || getCM(view);
  if (cm) {
    try { Vim.handleKey(cm, "<Esc>", "user"); } catch (_) {}
    try { Vim.handleKey(cm, "<Esc>", "user"); } catch (_) {}
  }

  view.dispatch({
    changes: { from: 0, to: view.state.doc.length, insert: ex.start },
    selection: { anchor: startPos },
  });

  // Unflag done only visually (do not remove from PROGRESS - keep history)
  info.done = false;
  // The reset itself is not the learner's change (undo exercises need one).
  info.changed = false;
  // Clear the recorded key history so the learner starts fresh.
  info.typedKeyStr = "";
  const outer = document.getElementById(`editor-${ex.id}`);
  if (outer) outer.classList.remove("correct");
  const msg = document.getElementById(`ok-${ex.id}`);
  if (msg) msg.style.display = "none";
  clearTokenHint(ex.id);

  view.focus();
}

// ---------------------------------------------------------------------------
// Solution toggle
// ---------------------------------------------------------------------------

function toggleSolution(ex, card) {
  const sol = document.getElementById(`sol-${ex.id}`);
  if (!sol) return;
  const btn = card.querySelector('[data-es="Ver solucion"], [data-es="Ocultar solucion"], [data-es="Ver solución"], [data-es="Ocultar solución"]');
  if (sol.style.display === "none") {
    sol.style.display = "block";
    if (btn) {
      btn.dataset.es = "Ocultar solución";
      btn.dataset.en = "Hide solution";
      btn.textContent = LANG === "es" ? "Ocultar solución" : "Hide solution";
      btn.setAttribute("aria-expanded", "true");
    }
  } else {
    sol.style.display = "none";
    if (btn) {
      btn.dataset.es = "Ver solución";
      btn.dataset.en = "Show solution";
      btn.textContent = LANG === "es" ? "Ver solución" : "Show solution";
      btn.setAttribute("aria-expanded", "false");
    }
  }
}

// ---------------------------------------------------------------------------
// Theme watch
// ---------------------------------------------------------------------------

window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
  // Reinitialize editors on theme change to pick up oneDark / light
  const main = document.querySelector(".main-content");
  const activeLessonId = main?.querySelector("[data-exercise-id]")
    ?.closest(".main-content")
    ? DATA?.lessons.find(l =>
        (l.exercises || []).some(ex =>
          document.getElementById(`cm-${ex.id}`) !== null
        ))?.id
    : null;
  if (activeLessonId) showLesson(activeLessonId);
});

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

document.addEventListener("DOMContentLoaded", main);
