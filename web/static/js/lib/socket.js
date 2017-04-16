import { Socket } from "phoenix"

export default function bootSocket(editor) {

  const socket = new Socket("/socket", {params: {token: window.userToken}})
  const bowlSession = window.location.pathname.split('/')[2]

  socket.connect()

  const channel = socket.channel(`bowl:${bowlSession}`, {})
  const chatInput = document.querySelector("#chat-input")
  const editorInput = document.querySelector("#editor")
  const messagesContainer = document.querySelector("#messages")
  const selectLang = document.querySelector("#select_lang")

  select_lang.onchange = (e) => {
    editor.getSession().setMode(`ace/mode/${event.target.value}`);
    let msg = {lang: event.target.value}
    channel.push("lang_change", msg)
  };

  editor.getSession().on('change', (e) => {
    if (e.lines.length === 1) {
      let msg = {body: editor.getValue(), row: e.end.row, column: e.end.column}
      channel.push("editor_change", msg)
    }
  });

  channel.on("editor_change", payload => {
    if (editor.getValue() !== payload.body) {
      editor.getSession().setValue(payload.body)
      editor.moveCursorToPosition({row: payload.row, column: payload.column})
    }
  })

  channel.on("lang_change", payload => {
    if (editor.getSession().getMode().$id !== `ace/mode/${payload.lang}`) {
      selectLang.value = payload.lang;
      editor.getSession().setMode(`ace/mode/${payload.lang}`);
    }
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

}
