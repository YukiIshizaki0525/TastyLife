'use strict'

{
  const tabItems = document.querySelectorAll('.user .user__stats a');

  tabItems.forEach(item => {
    item.addEventListener('click', e => {
      e.preventDefault();
      item.classList.add('active');
    })
  })
}