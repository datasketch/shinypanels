var panelsList = document.querySelectorAll('.panel--small');
var panels = Array.prototype.map.call(panelsList, function (element) {
	return element;
});
var preview = document.getElementById('preview');
var opossitePanel;

panels.forEach(function(panel) {
	panel.addEventListener('click', panelHandler);
});

function panelHandler (event) {
	if (!(event.target.matches('.panel-collapse__close') || event.target.matches('line'))) {
		return;
	}
	// Click en panel abierto
	var clickedPanel = this;
	opossitePanel = panels.find(function (element) { return element !== clickedPanel });

	if (!clickedPanel.classList.contains('collapsed') && !clickedPanel.classList.contains('expanded')) {
		clickedPanel.classList.add('collapsed');
		opossitePanel.classList.add('expanded');
		preview.style.width = '51%';
	} else if (clickedPanel.classList.contains('collapsed')) {
		clickedPanel.classList.remove('collapsed');
		if (opossitePanel.classList.contains('collapsed')) {
			clickedPanel.classList.add('expanded');
		} else {
			opossitePanel.classList.remove('expanded');
		}
		preview.style.width = '54%';
	} else if (clickedPanel.classList.contains('expanded')) {
		clickedPanel.classList.remove('expanded');
		clickedPanel.classList.add('collapsed');
		preview.style.width = '93%';
	}
}


var modalTrigger = document.querySelector('.modal-trigger');
modalTrigger.addEventListener('click', function (event) {
  event.preventDefault();
  modalWrapper.classList.add('opened')
  modal.classList.add('opened')
})
