const layoutSettings = {
  minWidth: '600px',
  panelClass: 'panel',
  panelCollapsedClass: 'collapsed',
  panelHeaderClass: 'panel',
  panelHeaderTitleClass: 'panel-header-title',
  panelDismissClass: 'panel-header-dismiss',
  panelBodyClass: 'panel-body'
}
const panels = Array.from(
  document.querySelectorAll(`.${layoutSettings.panelClass}`)
)
const dismiss = Array.from(
  document.querySelectorAll(`.${layoutSettings.panelDismissClass}`)
)

function setPanelWidth (panel, reset) {
  if (!reset) {
    if (panel.dataset.width) {
      panel.style.width = `${panel.dataset.width}px`
    } else {
      panel.style['flex-grow'] = '1'
      panel.style['min-width'] = layoutSettings.minWidth
    }
  } else {
    if (!panel.dataset.width) {
      panel.style['flex-grow'] = '0'
      panel.style['min-width'] = '0'
    }
    panel.style.width = 'auto'
  }
}

function showModalJs (modalID) {
  const modal = document.getElementById(modalID)
  modal.classList.add('is-visible')
  modal.addEventListener('click', (event) => {
    if (
      event.target.matches('.modal-title button') ||
      event.target.matches('.modal') ||
      event.target.matches('.modal-title svg') ||
      event.target.matches('.modal-title path')
    ) {
      modal.classList.remove('is-visible')
    }
  })
}

for (const panel of panels) {
  setPanelWidth(panel, panel.classList.contains('collapsed'))
  panel.addEventListener('click', function onPanelClick () {
    const isCollapsed = this.classList.contains(layoutSettings.panelCollapsedClass)
    if (isCollapsed) {
      setPanelWidth(this)
      this.classList.toggle(layoutSettings.panelCollapsedClass)
    }
  })
}

for (const button of dismiss) {
  button.addEventListener('click', function onDismissBtnClick (event) {
    const panel = this.parentNode.parentNode
    const isCollapsed = panel.classList.contains(layoutSettings.panelCollapsedClass)
    setPanelWidth(panel, !isCollapsed)
    panel.classList.toggle(layoutSettings.panelCollapsedClass)
    event.stopPropagation()
  })
}

$(document).ready(() => {
  Shiny.addCustomMessageHandler('showModalManually', (modalID) => {
    showModalJs(modalID)
  })
})

$(document).ready(() => {
  Shiny.addCustomMessageHandler('removeModalManually', (modalID) => {
    const modal = document.getElementById(modalID)
    modal.classList.remove('is-visible')
  })
})

$(document).on('shiny:value', (event) => {
  const modalTriggers = Array.prototype.map.call(
    document.querySelectorAll('.modal-trigger'),
    (e) => e
  )
  const modals = Array.prototype.map.call(
    document.querySelectorAll('.modal'),
    (e) => e
  )
  if (modals) {
    const refNode = document.querySelector('.layout-container')
    modals.forEach((modal) => {
      if (
        modal.dataset.fullscreen &&
        modal.dataset.fullscreen.match(/T|TRUE/)
      ) {
        refNode.parentNode.insertBefore(modal, refNode)
      }
    })
  }
  if (modalTriggers) {
    // Add listener to triggers
    modalTriggers.forEach((modalTrigger) => {
      function handleModalTrigger (event) {
        const modal = document.getElementById(this.dataset.modal)
        modal.classList.add('is-visible')
        modal.addEventListener('click', (event) => {
          if (
            event.target.matches('.modal-title button') ||
            event.target.matches('.modal') ||
            event.target.matches('.modal-title svg') ||
            event.target.matches('.modal-title path')
          ) {
            modal.classList.remove('is-visible')
          }
        })
      }
      modalTrigger.addEventListener('click', handleModalTrigger)
    })
  }
})

$('#ss-reload-link').attr('style', 'margin-top: 31px !important;')

$(document).ready(() => {
  Shiny.addCustomMessageHandler('showModalMultiple', (e) => {
    const modalId = e.inputId
    const triggerEl = document.getElementById(e.apply_id)
    const container = document.createElement('div')
    const mask = document.createElement('div')

    // Add attrs
    container.style.position = 'relative'
    mask.setAttribute('style', 'height: 100%; left: 0; top: 0; width: 100%; z-index: 1; position: absolute;')

    // Append
    triggerEl.insertAdjacentElement('beforebegin', container)
    container.appendChild(mask)
    container.appendChild(triggerEl)

    container.addEventListener('click', () => {
      showModalJs(modalId)
    })
  })
})
