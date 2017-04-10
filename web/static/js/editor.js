const editor = ace.edit("editor");

editor.$blockScrolling = Infinity;
editor.setTheme("ace/theme/cobalt");
editor.setShowInvisibles(true);
editor.setBehavioursEnabled(false);
editor.setShowPrintMargin(false);
editor.getSession().setUseWorker(false);
editor.getSession().setMode("ace/mode/javascript");

export default editor;
