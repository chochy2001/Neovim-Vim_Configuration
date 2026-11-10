// Everything app.js imports from CodeMirror, bundled once (see package.json).
export {
  EditorView,
  keymap,
  lineNumbers,
  drawSelection,
  highlightActiveLine,
  highlightActiveLineGutter,
} from "@codemirror/view";
export { EditorState, Prec } from "@codemirror/state";
export { defaultKeymap, historyKeymap, history } from "@codemirror/commands";
export { oneDark } from "@codemirror/theme-one-dark";
export { vim, Vim, getCM } from "@replit/codemirror-vim";
export { indentUnit } from "@codemirror/language";
