import { ScrollObserver } from './libs/scroll'

document.addEventListener("DOMContentLoaded", function () {
	new Main();
  new MobileMenu();
});

class Main {
	constructor() {
		this.header = document.querySelector(".header");
		this._observers = [];
		this._scrollInit();
	}

	_navAnimation = function (el, inview) {
		if (inview) {
			this.header.classList.remove("triggered");
		} else {
			this.header.classList.add("triggered");
		}
	};

	_scrollInit() {
		this._observers.push(
			new ScrollObserver(".nav-trigger", this._navAnimation.bind(this))
		);
	}
}

class MobileMenu {
  constructor() {
		this.DOM = {}
		this.DOM.btn = document.querySelector('.mobile-menu__btn');
    this.DOM.cover = document.querySelector('.mobile-menu__cover');
		this.DOM.container = document.querySelector('#global-container');
		this.eventType = this._getEventType();
		this._addEvent();
  }
  
  // スマホかPCかの切り分け
	_getEventType() {
		return window.ontouchstart ? 'touchstart' : 'click';
	}
	_toggle() {
		this.DOM.container.classList.toggle('menu-open');
	}

	_addEvent() {
		this.DOM.btn.addEventListener(this.eventType, this._toggle.bind(this));
		this.DOM.cover.addEventListener(this.eventType, this._toggle.bind(this));
	}
}