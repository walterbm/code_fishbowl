import MainView from '../main';
import bootSocket from '../../lib/socket';
import editorFactory from '../../lib/editor';

export default class View extends MainView {
  mount() {
    super.mount();
    const editor = editorFactory();
    bootSocket(editor);
  }

  unmount() {
    super.unmount();
  }
}
