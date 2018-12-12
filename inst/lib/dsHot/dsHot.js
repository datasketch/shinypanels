(function() {
	var columsSelected;
	// BINDINGS
	var dsHotBinding = new Shiny.InputBinding();

	dsHotBinding.find = function (scope) {
		// console.log("FIND: ", $(scope).find(".hot"));
		return $(scope).find('.hot');
	};

	dsHotBinding.initialize = function (el) {
		// console.log("INIT: ", el.id);
		// // var elid = document.getElementsByClassName('hot');
		var elid = $(el);
		console.log('i', elid);
		// https://jsfiddle.net/04r5cgsb/1/ add comments to cells
		window.userSelectedColumns = undefined;
		var settings = {};
		settings.maxRows = 50;
		var rowsIdx = Array.from(new Array(settings.maxRows), function (val, index) { return index + 1 });
		settings.availableCtypes = ['Numeric', 'Categoric', 'Date'];

		// var hotElement = document.querySelector('#hot');
		// var hotElement = elid[0];
		var params = formatDataParams(el);
		console.log('params', params);
		var hotElementContainer = el.parentNode;
		var hotSettings = {
			data: params.dataObject,
			columns: params.dataDic,
			stretchH: 'none',
			width: params.hotOpts.width || $(el).parent().width(),
			autoWrapRow: params.hotOpts.autoWrapRow,
			height: params.hotOpts.height,
			maxRows: params.hotOpts.maxRows + 2,
			rowHeaders: [null, null].concat(rowsIdx),
			colHeaders: true,
			fixedRowsTop: 2,
			// preventOverflow: 'horizontal',
			manualRowMove: params.hotOpts.manualRowMove,
			manualColumnMove: params.hotOpts.manualColumnMove,
			selectionMode: "multiple",
			// invalidCellClassName: 'highlight--error',
			cells: function(row, col, prop) {
				// console.log(this);
				if (row === 0) {
					this.renderer = ctypeRenderer;
					this.type = 'dropdown';
					this.source = settings.availableCtypes;
					this.validator = null;
					return (this)
				}
				if (row === 1) {
					// console.log(row)
					this.renderer = headRenderer;
					this.validator = null;
					return (this)
				}
				//Get current ctype
				var ctype = this.instance.getDataAtCell(0, col);
				if (ctype == 'Numeric') {
					this.validator = valiNumeric;
				}
				if (ctype == 'Categoric') {
					this.validator = valiCategoric;
				}
			},
			// Bind event after selection
      afterSelectionEnd: function (startRow, startColumn, endRow, endColumn, layer) {
        if (startRow !== 0) {
          return
        }
        var selected = {};
        // If greater than 0, the user selected multiple columns using CTRL key
        selected.layer = layer
        selected.columns = this.getSelected().reduce(function (cols, range) {
          cols.push(range[1]); // Start column
          cols.push(range[3]); // End column
          return cols;
        }, []);
        // Unique values
        selected.columns = selected.columns.reduce(function (cols, col) {
          // Short-circuit evaluation
          !cols.includes(col) && cols.push(col)
          return cols;
        }, []);
        // Filter dictionary and save under global window object
				// Save under global window object
        window.userSelectedColumns = filterDict.apply(this, [selected])
      }
		};
		var filterDict = function (info) {
      var props = []
      var self = this;
      if (info.layer > 0) {
        // Each value represents a column
        info.columns.map(function (col) {
          var meta = self.getCellMeta(0, col);
          props.push(meta.prop)
        })
      } else {
        // The array represents a range
        var start = info.columns[0]
        var end = info.columns[1] || start
        for (var i = start; i <= end; i++) {
          var meta = self.getCellMeta(0, i);
          props.push(meta.prop)
        }
      }
      return params.dataDic.filter(function (item) {
        return props.includes(item.id)
      })
    }
		console.log('elid', el.id)
		var hot = new Handsontable(el, hotSettings);
		console.log('HOT', hot);
		hot.validateCells();
		window[[el.id]] = hot;

		// hot.getPlugin('autoColumnSize');

		/* document.addEventListener('mousemove', function(event) {
			hot.updateSettings({
				width: $('.hot').parent().width()
			});
		}); */

		// updateChooser(el);
	};

	dsHotBinding.getValue = function (el) {
		var hot = window[[el.id]];
		var userSelectedCols = window.userSelectedColumns
		console.log('getHot', window[[el.id]]);
		return JSON.stringify(parseHotInput(hot.getData(), userSelectedCols));
	};

	dsHotBinding.setValue = function(el, value) {
		// TODO: implement
	};

	dsHotBinding.subscribe = function(el, callback) {
		/* document.addEventListener('mousemove', function(event) {
			var hot = window[[el.id]];
			hot.updateSettings({
				width: $(el).parent().width()
			});
			callback();
		}); */
		$(el).on('change.hotBinding', function (e) {
			callback();
		});
	};

	dsHotBinding.unsubscribe = function(el) {
		$(el).off('.hotBinding');
	};

	dsHotBinding.getType = function() {
		return 'dsHotBinding';
	};

	Shiny.inputBindings.register(dsHotBinding);
})();
