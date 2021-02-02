const layoutSettings = {
  minWidth: '600px',
  panelClass: 'panel',
  panelCollapsedClass: 'collapsed',
  panelHeaderClass: 'panel',
  panelHeaderTitleClass: 'panel-header-title',
  panelDismissClass: 'panel-header-dismiss',
  panelBodyClass: 'panel-body',
};
const panels = Array.from(
  document.querySelectorAll('.' + layoutSettings.panelClass)
);
const headers = Array.from(
  document.querySelectorAll('.' + layoutSettings.panelHeaderClass)
);
const dismiss = Array.from(
  document.querySelectorAll('.' + layoutSettings.panelDismissClass)
);

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

function showModalJs(modalID) {
  var modal = document.getElementById(modalID);
  modal.classList.add('is-visible');
  modal.addEventListener('click', function (event) {
    if (
      event.target.matches('.modal-title button') ||
      event.target.matches('.modal') ||
      event.target.matches('.modal-title svg') ||
      event.target.matches('.modal-title path')
    ) {
      modal.classList.remove('is-visible');
    }
  });
}

for (let panel of panels) {
  setPanelWidth(panel, panel.classList.contains('collapsed'));
}

for (let button of dismiss) {
  button.addEventListener('click', function (event) {
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
  header.addEventListener('click', function (event) {
    const panel = this;
    if (
      panel.classList.contains(layoutSettings.panelCollapsedClass) &&
      (event.target === this ||
        event.target.matches('.' + layoutSettings.panelHeaderTitleClass))
    ) {
      panel.classList.toggle(layoutSettings.panelCollapsedClass);
      setPanelWidth(panel);
    }
  });
}

$(document).ready(function () {
  Shiny.addCustomMessageHandler('showModalManually', function (modalID) {
    showModalJs(modalID);
  });
});

$(document).ready(function () {
  Shiny.addCustomMessageHandler('removeModalManually', function (modalID) {
    var modal = document.getElementById(modalID);
    modal.classList.remove('is-visible');
  });
});

$(document).on('shiny:value', function (event) {
  const modalTriggers = Array.prototype.map.call(
    document.querySelectorAll('.modal-trigger'),
    function (e) {
      return e;
    }
  );
  const modals = Array.prototype.map.call(
    document.querySelectorAll('.modal'),
    function (e) {
      return e;
    }
  );
  if (modals) {
    const refNode = document.querySelector('.layout-container');
    modals.forEach(function (modal) {
      if (
        modal.dataset.fullscreen &&
        modal.dataset.fullscreen.match(/T|TRUE/)
      ) {
        refNode.parentNode.insertBefore(modal, refNode);
      }
    });
  }
  if (modalTriggers) {
    // Add listener to triggers
    modalTriggers.forEach(function (modalTrigger) {
      function handleModalTrigger(event) {
        var modal = document.getElementById(this.dataset.modal);
        modal.classList.add('is-visible');
        modal.addEventListener('click', function (event) {
          if (
            event.target.matches('.modal-title button') ||
            event.target.matches('.modal') ||
            event.target.matches('.modal-title svg') ||
            event.target.matches('.modal-title path')
          ) {
            modal.classList.remove('is-visible');
          }
        });
      }
      modalTrigger.addEventListener('click', handleModalTrigger);
    });
  }
});

$('#ss-reload-link').attr('style', 'margin-top: 31px !important;');

$(document).ready(function () {
  Shiny.addCustomMessageHandler('showModalMultiple', function (e) {
    const modalId = e.inputId;
    const triggerEl = document.getElementById(e.apply_id);
    const container = document.createElement('div');
    const mask = document.createElement('div');

    // Add attrs
    container.style.position = 'relative';
    mask.setAttribute('style', 'height: 100%; left: 0; top: 0; width: 100%; z-index: 1; position: absolute;');

    // Append
    triggerEl.insertAdjacentElement('beforebegin', container)
    container.appendChild(mask);
    container.appendChild(triggerEl);

    container.addEventListener('click', function () {
      showModalJs(modalId);
    });
  });
});
