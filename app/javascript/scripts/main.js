import { ScrollObserver } from './libs/scroll'

window.addEventListener('turbolinks:load', function () {
	new Main();
	new MobileMenu();
	new addFields();
	new removeFields();
	
	if (document.URL.match("recipes/new") ||
		document.URL.match("recipes/[0-9]+/edit") ||
		document.URL.match("users/edit") ||
		document.URL.match("inventories/[0-9]+/edit")
	) {
		new imgPreView();
	}

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

class addFields {
	constructor(){
    this.links = document.querySelectorAll('.js-add_fields');
    this.iterateLinks();
  }

  iterateLinks() {
    if(this.links.length === 0) return;
    this.links.forEach((link)=>{
        link.addEventListener('click', (e) => {
            this.handleClick(link, e);
        });
    });
  }

  handleClick(link, e) {
    if (!link || !e) return;
    e.preventDefault();
    let time = new Date().getTime();
    let linkId = link.dataset.id;
    let regexp = linkId ? new RegExp(linkId, 'g') : null ;
    let newFields = regexp ? link.dataset.fields.replace(regexp, time) : null ;
    newFields ? link.insertAdjacentHTML('beforebegin', newFields) : null ;
  }

}
class removeFields {
  constructor(){
    this.iterateLinks();
  }

  iterateLinks() {
		document.addEventListener('click', e => {
			if (e.target && e.target.className == 'js-remove_fields') {
				this.handleClick(e.target, e)
			}
		})
  }

  handleClick(link, e) {
    if (!link || !e) return
    e.preventDefault()
    let fieldParent = link.closest('.nested-fields')
    let deleteField = fieldParent
      ? fieldParent.querySelector('input[type="hidden"]')
      : null
    if (deleteField) {
      deleteField.value = 1
      fieldParent.style.display = 'none'
    }
  }
}

class imgPreView{
	constructor() {
		this.element = document.querySelector('.image')
		this.preview = document.querySelector('.preview')
		this.set_img = document.querySelector('#set-img')
		this.description_img = document.querySelector('.description__img')
		this.img_remove = document.querySelector('#img_remove')
		this.preview.style.display ="none";
		this._preview();

	}

	_preview() {
			this.element.addEventListener('input', (event) => {
			const target = event.target
			const files = target.files
			const file = files[0]

			const reader = new FileReader()
			
			reader.onload = () => {
				const img = new Image()
				img.src = reader.result
				if (this.set_img != undefined) {
					this.description_img.remove();
					this.img_remove.remove();
				}
				this.preview.appendChild(img)
				this.preview.style.display = "block";
			}
			reader.readAsDataURL(file)
		})
	}

}

