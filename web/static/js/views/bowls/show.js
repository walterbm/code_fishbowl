import MainView from '../main';
import Editor from '../../lib/editor';
import Channel from '../../lib/channel';



export default class View extends MainView {
  mount() {
    super.mount();

    const editor = new Editor({
      id: 'editor',
      theme: 'chaos',
      lang: 'javascript'
    });
    const channel = new Channel({
      editor,
      endpoint: '/socket',
      chatId: '#chat-input',
      editorInputId: '#editor',
      selectLangId: '#select_lang'
    })
  }

  unmount() {
    super.unmount();
  }
}
