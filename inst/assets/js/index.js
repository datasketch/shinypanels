const settings = {
  minWidth: '600px',
  panelClass: 'panel',
  panelCollapsedClass: 'collapsed',
  panelHeaderClass: 'panel-header',
  panelHeaderTitleClass: 'panel-header-title',
  panelDismissClass: 'panel-header-dismiss',
  panelBodyClass: 'panel-body'
}
const panels = Array.from(document.querySelectorAll('.' + settings.panelClass));
const headers = Array.from(document.querySelectorAll('.' + settings.panelHeaderClass));
const dismiss = Array.from(document.querySelectorAll('.' + settings.panelDismissClass));

function setPanelWidth(panel, reset) {
  if (!reset) {
    if (panel.dataset.width) {
      panel.style.width = `${panel.dataset.width}px`;
    } else {
      panel.style['flex-grow'] = '1';
      panel.style['min-width'] = settings.minWidth;
    }
  } else {
    if (!panel.dataset.width) {
      panel.style['flex-grow'] = '0';
      panel.style['min-width'] = '0';
    }
    panel.style.width = 'auto';
  }
}

for (let panel of panels) {
  setPanelWidth(panel, panel.classList.contains('collapsed'));
}

for (let button of dismiss) {
  button.addEventListener('click', function(event) {
    console.log("cuqla");
    const panel = this.parentNode.parentNode;
    if (!panel.classList.contains(settings.panelCollapsedClass)) {
      setPanelWidth(panel, true);
    } else {
      setPanelWidth(panel);
    }
    panel.classList.toggle(settings.panelCollapsedClass);
  });
}

for (let header of headers) {
  header.addEventListener('click', function(event) {
    const panel = this.parentNode;
    if (
      panel.classList.contains(settings.panelCollapsedClass) &&
      (event.target === this || event.target.matches('.' + settings.panelHeaderTitleClass))
    ) {
      panel.classList.toggle(settings.panelCollapsedClass);
      setPanelWidth(panel);
    }
  });
}


const modalTriggers = Array.prototype.map.call(
  document.querySelectorAll('.modal-trigger'),
  function (e) { return e; }
);

if (modalTriggers) {
  modalTriggers.forEach(function (modalTrigger) {
    function handleModalTrigger(event) {
      var modal = document.getElementById(this.dataset.modal);
      modal.classList.add('is-visible');
      modal.addEventListener('click', function(event) {
        if (event.target.matches('.modal-title button') || event.target.matches('.modal') || event.target.matches('.modal-title svg')) {
          modal.classList.remove('is-visible');
        }
      });
    }
    modalTrigger.addEventListener('click', handleModalTrigger);
  });
}






