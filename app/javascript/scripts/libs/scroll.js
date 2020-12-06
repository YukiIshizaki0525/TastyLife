export class ScrollObserver {
  constructor(els, cb) {
    this.els = document.querySelectorAll(els);
    this.cb = cb;
    this._init();
  }
  _init() {
    const callback = function (entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.cb(entry.target, true);
                if(this.once) {
                    observer.unobserve(entry.target);
                }
            } else {
                this.cb(entry.target, false);
            }
        });
    };

    this.io = new IntersectionObserver(callback.bind(this));

		this.io.POLL_INTERVAL = 100;
		
    this.els.forEach(el => this.io.observe(el));
  }

  // destroy() {
  //     this.io.disconnect();
  // }
}
