export default class Editor {

  constructor({ id, lang, theme }) {
    this.editor = ace.edit(id);
    this.editor.$blockScrolling = Infinity;
    this.editor.setTheme(`ace/theme/${theme}`);
    this.editor.setShowInvisibles(true);
    this.editor.setBehavioursEnabled(false);
    this.editor.setShowPrintMargin(false);
    this.editor.getSession().setUseWorker(false);
    this.editor.getSession().setMode(`ace/mode/${lang}`);
  }

  get() {
    return this.editor;
  }

  getSession() {
    return this.editor.getSession()
  }

  getValue() {
    return this.editor.getValue()
  }

  getLang() {
    return this.editor.getSession().getMode().$id
  }

  setValue(value) {
    this.editor.getSession().setValue(value)
  }

  setCursor({ row, column }) {
    this.editor.moveCursorToPosition({ row, column })
  }

  setLang(lang) {
    this.editor.getSession().setMode(`ace/mode/${lang}`);
  }

}
