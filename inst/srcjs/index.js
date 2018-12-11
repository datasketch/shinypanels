var layout = document.querySelector('.layout');
var dragbar = document.querySelector('.js-drag');
var dataArea = document.querySelector('.data');
var vizArea = document.querySelector('.viz');
var dataNav = document.querySelector('.data__nav');
var vizNav = document.querySelector('.viz__nav');
var vizResult = document.querySelector('.viz__result');
var vizSettings = document.querySelector('.viz__settings');
var dataSettings = document.querySelector('.data__settings');
var dataPreview = document.querySelector('.data__preview');
var editGraphic = document.getElementById('edit-graphic');
var editData = document.getElementById('edit-data');
var isDraggin = false;
var minWidth = '25%';
var maxWidth = '75%';
var eqWidth = '50%';
var modalTrigger = document.querySelector('.modal-trigger');
console.log(modalTrigger)
var modalWrapper = document.querySelector('.ds__modal-wrapper');
var modal = document.querySelector('.ds__modal');
var dsTabs = document.querySelector('.ds__tabs');
var activeTab = document.querySelector('.ds__tab.active');


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
    altWidth([vizArea, vizNav], maxWidth);
  } else if (width > 75) {
    altWidth([dataArea, dataNav], maxWidth);
    altWidth([vizArea, vizNav], minWidth);
  } else {
    altWidth([dataArea, dataNav], `${width}%`);
    altWidth([vizArea, vizNav], `${100 - width}%`);
  }
});

document.addEventListener('mouseup', function (event) {
  isDraggin = false;
})

editGraphic.addEventListener('click', function (event) {
  event.preventDefault();
  editData.classList.remove('active')
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
    altWidth([vizArea, vizNav], maxWidth);
    vizResult.classList.add('shrinked');
    vizSettings.classList.add('grown');
    dataSettings.classList.remove('grown');
    dataPreview.classList.remove('shrinked');
  } else {
    altWidth([dataArea, dataNav], eqWidth);
    altWidth([vizArea, vizNav], eqWidth);
    vizResult.classList.remove('shrinked');
    vizSettings.classList.remove('grown');
  }
});

editData.addEventListener('click', function (event) {
  event.preventDefault()
  editGraphic.classList.remove('active')
  // Set active class to change color
  this.classList.toggle('active');
  // Remove to-left class if exists
  if (layout.classList.contains('to-left')) {
    layout.classList.remove('to-left');
  }
  // Toggle to-right class
  layout.classList.toggle('to-right')
  // Manage sections width
  /*altWidth([dataArea, dataNav], maxWidth);
  altWidth([vizArea, vizNav], minWidth);
  vizResult.classList.remove('shrinked');
  vizSettings.classList.remove('grown');
  dataSettings.classList.add('grown');
  dataPreview.classList.add('shrinked');*/
  // Manage sections width
  if (layout.classList.contains('to-right')) {
    altWidth([dataArea, dataNav], maxWidth);
    altWidth([vizArea, vizNav], minWidth);
    vizResult.classList.remove('shrinked');
    vizSettings.classList.remove('grown');
    dataSettings.classList.add('grown');
    dataPreview.classList.add('shrinked');
  } else {
    altWidth([dataArea, dataNav], eqWidth);
    altWidth([vizArea, vizNav], eqWidth);
    dataPreview.classList.remove('shrinked');
    dataSettings.classList.remove('grown');
  }
})

modalTrigger.addEventListener('click', function (event) {
  event.preventDefault();
  modalWrapper.classList.add('opened')
  modal.classList.add('opened')
})

modalWrapper.addEventListener('click', function (event) {
  event.preventDefault();
  this.classList.remove('opened')
  modal.classList.remove('opened')
})

function altWidth(el, val) {
  Array.isArray(el)
    ? el.forEach(e => e.style.width = val)
    : el.style.width = val
}


dsTabs.addEventListener('click', function (event) {
  var element = event.target;
  if (!element.matches('.ds__tab') || element === activeTab) {
    return;
  }
  // Set active
  activeTab = element;
  // Get tab id
  const tab = element.dataset.tab;
  // Get tab content div
  const content = document.getElementById(tab);
  // Remove class to actual active element
  document.querySelector('.ds__tab.active').classList.remove('active');
  // Add class to clicked element
  element.classList.add('active');
  // Hide actual active tab content
  document.querySelector('.ds__tab-content-pane.active').classList.remove('active');
  // Show content
  content.classList.add('active');
});




