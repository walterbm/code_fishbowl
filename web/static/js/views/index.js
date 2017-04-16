import MainView from './main';
import BowlShowView from './bowls/show';

const views = {
  BowlShowView
};

export default function loadView(viewName) {
  console.log(`Loading: ${viewName}`);
  return views[viewName] || MainView;
}
