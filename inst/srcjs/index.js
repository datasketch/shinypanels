var PANEL_THRESHOLD = 2;
var EXPANDED_CLASS = 'panel--expanded';
var COLLAPSED_CLASS = 'is-collapsed';
var panels = Array.prototype.map.call(document.querySelectorAll('.is-collapsable'), function (panel) {
	panel.addEventListener('click', panelHandler);
	return panel;
});
var preview = document.querySelector('.is-not-collapsable');
var publish = document.getElementById('publish-trigger');
var modal = document.querySelector('.modal-wrapper');
var modalDismiss = document.querySelector('.modal-dismiss');
var modalActions = Array.prototype.map.call(document.querySelectorAll('.modal-action-label'), function (action) {
	action.addEventListener('click', actionHandler);
	return action
});


function countPanelsCollapsed () {
	var collapsed = panels.filter(function (panel) {
		return panel.classList.contains(COLLAPSED_CLASS);
	});
	return collapsed.length;
}

function onePanelLeftToCollapse () {
	return countPanelsCollapsed() === PANEL_THRESHOLD
}

function panelHandler (event) {
	if (!(event.target.matches('.icon-close') || event.target.matches('line'))) {
		return;
	}
	var clickedPanel = this;
	/**
	 * Could be 2 cases:
	 * 1. Clicked panel is for settings
	 * 2. Clicked panel is not for settings
	 */
	// Case 1:
	if (clickedPanel.classList.contains('has-settings')) {
		var oppositePanel = panels.find(function (panel) {
			return panel !== clickedPanel && panel.classList.contains('has-settings');
		});
		var notSettings = panels.find(function (panel) {
			return !panel.classList.contains('has-settings');
		});
		var clickedPanelIsClosed = clickedPanel.classList.contains(COLLAPSED_CLASS);
		var oppositePanelIsClosed = oppositePanel.classList.contains(COLLAPSED_CLASS);
		/**
		 * Could be 3 cases:
		 * 1a. Clicked panel is closed and opposite panel is closed
		 * 1b. Clicked panel is closed open and opposite panel is open
		 * 1c. Clicked panel is open
		 */
		if (clickedPanelIsClosed) {
			if (oppositePanelIsClosed) { // 1a
				// Open clickedPanel
				clickedPanel.classList.remove(COLLAPSED_CLASS);
			} else { // 1b
				// Close oppositePanel and open clickedPanel
				oppositePanel.classList.add(COLLAPSED_CLASS);
				clickedPanel.classList.remove(COLLAPSED_CLASS);
			}
		} else {
			// Close clicked panel
			clickedPanel.classList.add(COLLAPSED_CLASS);
		}
	} else {
		// Case 2
		clickedPanel.classList.toggle(COLLAPSED_CLASS);
	}
	// Manage panel expand
	var expandedPanel = document.querySelector('.' + EXPANDED_CLASS);
	// Remove expanded class from element if any
	expandedPanel && expandedPanel.classList.remove(EXPANDED_CLASS);
	if (!clickedPanel.classList.contains(COLLAPSED_CLASS)) {
		// Add expanded class if the clicked panel is the only one with opened state
		onePanelLeftToCollapse() && clickedPanel.classList.add(EXPANDED_CLASS);
	} else {
		var remainingPanel = panels.find(function (panel) {
			return !panel.classList.contains(COLLAPSED_CLASS);
		});
		// Add expanded class to the element if there is still one panel opened
		remainingPanel && remainingPanel.classList.add(EXPANDED_CLASS);
	}
	var panelsToCollapse = countPanelsCollapsed();
	switch (panelsToCollapse) {
		case 1:
			preview.classList.add('shrinked');
			preview.classList.remove('expanded');
			break;
		case 2:
			preview.classList.remove('shrinked');
			preview.classList.remove('expanded');
			break;
		case 3:
			preview.classList.add('expanded');
			preview.classList.remove('shrinked');
			break;
		default:
			preview.classList.remove('expanded');
			preview.classList.remove('shrinked');
			break;
	}
}


var clickAvanzados = document.querySelector(".titulo-avanzados");
var contentAvanzados  = document.querySelector(".contenido-avanzados");

/*
clickAvanzados.addEventListener("click", function() {
	clickAvanzados.classList.toggle( 'title-active' );
	clickAvanzados.childNodes[1].classList.toggle( 'show-active' );
	contentAvanzados.classList.toggle('content-avanzados');
  });
*/


publish.addEventListener('click', function (event) {
	event.preventDefault()
	console.log("hola");
	modal.classList.add('opened')
});

