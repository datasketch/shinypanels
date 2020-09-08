const layoutSettings = {
  minWidth: '600px',
  panelClass: 'panel',
  panelCollapsedClass: 'collapsed',
  panelHeaderClass: 'panel',
  panelHeaderTitleClass: 'panel-header-title',
  panelDismissClass: 'panel-header-dismiss',
  panelBodyClass: 'panel-body'
};
const panels = Array.from(document.querySelectorAll('.' + layoutSettings.panelClass));
const headers = Array.from(document.querySelectorAll('.' + layoutSettings.panelHeaderClass));
const dismiss = Array.from(document.querySelectorAll('.' + layoutSettings.panelDismissClass));

function setPanelWidth(panel, reset) {
  if (!reset) {
    if (panel.dataset.width) {
      panel.style.width = `${panel.dataset.width}px`;
    } else {
      panel.style['flex-grow'] = '1';
      panel.style['min-width'] = layoutSettings.minWidth;
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
    if (!panel.classList.contains(layoutSettings.panelCollapsedClass)) {
      setPanelWidth(panel, true);
    } else {
      setPanelWidth(panel);
    }
    panel.classList.toggle(layoutSettings.panelCollapsedClass);
  });
}

for (let header of headers) {
  header.addEventListener('click', function(event) {
    const panel = this;
    if (
      panel.classList.contains(layoutSettings.panelCollapsedClass) &&
      (event.target === this || event.target.matches('.' + layoutSettings.panelHeaderTitleClass))
    ) {
      panel.classList.toggle(layoutSettings.panelCollapsedClass);
      setPanelWidth(panel);
    }
  });
}

$(document).ready(function() {
  Shiny.addCustomMessageHandler('showModalManually', function(modalID) {
    var modal = document.getElementById(modalID);
    modal.classList.add('is-visible');
    modal.addEventListener('click', function(event) {
      if (event.target.matches('.modal-title button') || event.target.matches('.modal') || event.target.matches('.modal-title svg') || event.target.matches('.modal-title path')) {
        modal.classList.remove('is-visible');
      }
    });
  })
});

$(document).ready(function() {
  Shiny.addCustomMessageHandler('removeModalManually', function(modalID) {
    var modal = document.getElementById(modalID);
    modal.classList.remove('is-visible');
  });
});

$(document).on('shiny:value', function(event) {

  const modalTriggers = Array.prototype.map.call(
    document.querySelectorAll('.modal-trigger'),
    function (e) { return e; });

  if (modalTriggers) {
    modalTriggers.forEach(function (modalTrigger) {
      // ### con esto no sirve en las apps (quedan dos modales iguales --mismo id)
        //  var modal_0 = document.getElementById(modalTrigger.dataset.modal)
        //  if (modal_0.getAttribute("whole_window") === "TRUE") {
          //    var parent_div = document.querySelector('body div.layout-container');
          //    parent_div.appendChild(modal_0);
          //  }
        function handleModalTrigger(event) {
          var modal = document.getElementById(this.dataset.modal);
          var parent = modal.parentElement;
          // ### con esto sirve pero la transición del modal no se ve en el primer click
          if (!parent.classList.contains("layout-container") && modal.getAttribute("whole_window") === "TRUE") {
            var parent_div = document.querySelector('body div.layout-container');
            parent_div.appendChild(modal);
          }
          modal.classList.add('is-visible');
          modal.addEventListener('click', function(event) {
            if (event.target.matches('.modal-title button') || event.target.matches('.modal') || event.target.matches('.modal-title svg') || event.target.matches('.modal-title path')) {
              modal.classList.remove('is-visible');
            }
          });
        }
        modalTrigger.addEventListener('click', handleModalTrigger);
    });
  }

});
