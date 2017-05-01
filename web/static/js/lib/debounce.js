const debounce = (fn, wait) => {
  let timeout;
  return function() {
    const context = this, args = arguments;
    const later = () => {
      console.log("LATER")
      timeout = null;
      fn.apply(context, args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
};

export default debounce
