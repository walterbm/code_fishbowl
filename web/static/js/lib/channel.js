import { Socket } from "phoenix"
import debounce from './debounce';

export default class Channel {

  constructor({ editor, endpoint, chatId, editorInputId, selectLangId }) {
    /* Connection & Component init */
    this.editor = editor
    this.socket = new Socket(endpoint, {params: {token: window.userToken}})
    this.socket.connect()
    this.session = window.location.pathname.split('/')[2]
    this.channel = this.socket.channel(`bowl:${this.session}`, {})

    /* DOM Elements */
    this.chatInput = document.querySelector(chatId)
    this.editorInput = document.querySelector(editorInputId)
    this.selectLang = document.querySelector(selectLangId)

    /* Change Callbacks */
    this.selectLang.onchange = this.handleLangChange.bind(this)
    this.channel.on("editor_change", debounce(this.handleEditorChangeIn.bind(this), 200))
    this.channel.on("lang_change", this.handleLangChangeIn.bind(this))
    this.channel.on("editor_set", this.handleEditorSetIn.bind(this))
    this.editor.getSession().on('change', this.handleEditorChange.bind(this))

    /* Join */
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  handleLangChange(e) {
    let lang = event.target.value
    this.editor.setLang(lang);
    this.channel.push("lang_change", { lang })
  }

  handleEditorChange(e) {
    let msg = {body: this.editor.getValue(), row: e.end.row, column: e.end.column}
    this.channel.push("editor_change", msg)
  }

  handleEditorChangeIn(payload) {
    if (payload.body !== this.editor.getValue()) {
      this.editor.setValue(payload.body)
      this.editor.setCursor({row: payload.row, column: payload.column})
    }
  }

  handleLangChangeIn(payload) {
    if (this.editor.getLang() !== `ace/mode/${payload.lang}`) {
      this.selectLang.value = payload.lang;
      this.editor.setLang(payload.lang);
    }
  }

  handleEditorSetIn(payload) {
    this.handleLangChangeIn(payload)
    this.handleEditorChangeIn(payload)
  }

}
