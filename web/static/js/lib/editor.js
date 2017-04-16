
export default function editorFactory() {
  const editor = ace.edit("editor");

  editor.$blockScrolling = Infinity;
  editor.setTheme("ace/theme/chaos");
  editor.setShowInvisibles(true);
  editor.setBehavioursEnabled(false);
  editor.setShowPrintMargin(false);
  editor.getSession().setUseWorker(false);
  editor.getSession().setMode("ace/mode/javascript");

  return editor;
}
