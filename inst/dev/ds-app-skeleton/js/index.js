var layout = document.querySelector('.layout');
var dragbar = document.querySelector('.js-drag');
var dataArea = document.querySelector('.data');
var visArea = document.querySelector('.vis');
var dataNav = document.querySelector('.data__nav');
var visNav = document.querySelector('.vis__nav');
var visResult = document.querySelector('.vis__result');
var visSettings = document.querySelector('.vis__settings');
var dataSettings = document.querySelector('.data__settings');
var dataPreview = document.querySelector('.data__preview');
var edit = document.getElementById('edit-graphic');
var isDraggin = false;
var minWidth = '25%';
var maxWidth = '75%';
var eqWidth = '50%';

document.addEventListener('mousedown', function (event) {
  if (event.target === dragbar) {
    isDraggin = true;
  }
});

document.addEventListener('mousemove', function (event) {
  if (!isDraggin) {
    return false;
  }

  window.getSelection().removeAllRanges();
  var width = (event.pageX - dragbar.offsetWidth) * 100 / window.innerWidth;

  if (width < 25) {
    altWidth([dataArea, dataNav], minWidth);
    altWidth([visArea, visNav], maxWidth);
  } else if (width > 75) {
    altWidth([dataArea, dataNav], maxWidth);
    altWidth([visArea, visNav], minWidth);
  } else {
    altWidth([dataArea, dataNav], `${width}%`);
    altWidth([visArea, visNav], `${100 - width}%`);
  }
});

document.addEventListener('mouseup', function (event) {
  isDraggin = false;
})

edit.addEventListener('click', function (event) {
  event.preventDefault();
  // Set active class to change color
  this.classList.toggle('active');
  // Remove to-right class if exists
  if (layout.classList.contains('to-right')) {
    layout.classList.remove('to-right');
  }
  // Toggle to-left class
  layout.classList.toggle('to-left')
  // Manage sections width
  if (layout.classList.contains('to-left')) {
    altWidth([dataArea, dataNav], minWidth);
    altWidth([visArea, visNav], maxWidth);
    visResult.classList.add('shrinked');
    visSettings.classList.add('grown');
    dataSettings.classList.remove('grown');
    dataPreview.classList.remove('shrinked');
  } else {
    altWidth([dataArea, dataNav], eqWidth);
    altWidth([visArea, visNav], eqWidth);
    visResult.classList.remove('shrinked');
    visSettings.classList.remove('grown');
  }
});

dataNav.addEventListener('click', function (event) {
  if (!event.target.matches('input[type="radio"]')) {
    return false
  }
  // Remove to-right class if exists
  if (layout.classList.contains('to-left')) {
    layout.classList.remove('to-left');
  }
  // Manage sections width
  altWidth([dataArea, dataNav], maxWidth);
  altWidth([visArea, visNav], minWidth);
  visResult.classList.remove('shrinked');
  visSettings.classList.remove('grown');
  dataSettings.classList.add('grown');
  dataPreview.classList.add('shrinked');
});

function altWidth(el, val) {
  Array.isArray(el)
    ? el.forEach(e => e.style.width = val)
    : el.style.width = val
}