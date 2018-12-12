(function() {
<<<<<<< HEAD
	// BINDINGS
	var binding = new Shiny.InputBinding();
	
	binding.find = function(scope) {
		// console.log("FIND: ", $(scope).find(".hot"));
		return $(scope).find(".hot");
	};

	binding.initialize = function(el) {

	// console.log("INIT: ", el.id);
	// // var elid = document.getElementsByClassName('hot');
	var elid = $(el);
	console.log("i", elid);
	// https://jsfiddle.net/04r5cgsb/1/ add comments to cells
	var settings = {};
	settings.maxRows = 50;
	var rowsIdx = Array.from(new Array(settings.maxRows), (val, index) => index + 1);
	settings.availableCtypes = ["Numeric", "Categoric", "Date"];

	// var hotElement = document.querySelector('#hot');
	// var hotElement = elid[0];
	var params = formatDataParams(el);
	console.log("params",params);
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
			if (ctype == "Numeric") {
				this.validator = valiNumeric;
			}
			if (ctype == "Categoric") {
				this.validator = valiCategoric;
			}
		}
	};
	console.log("elid",el.id)
	var hot = new Handsontable(el, hotSettings);
	console.log("HOT",hot);
	hot.validateCells();
	window[[el.id]] = hot;

	// hot.getPlugin('autoColumnSize');

	// document.addEventListener('mousemove', function(event) {
	//     hot.updateSettings({
	//         width: $('.hot').parent().width()
	//     });
	// });

	// updateChooser(el);
};
	binding.getValue = function (el) {
		var hot = window[[el.id]];
		console.log("getHot",window[[el.id]]);
		return parseHotInput(hot.getData())
	};

	binding.setValue = function (el, value) {
        // TODO: implement
	};

	binding.subscribe = function(el, callback) {
		// document.addEventListener('mousemove', function(event) {
		//     var hot = window[[el.id]];
		//     hot.updateSettings({
		//         width: $(el).parent().width()
		//     });
		//     callback();
		// });
		// $(el).on("change.hotBinding", function(e) {
		//     callback();
		// });
	};

	binding.unsubscribe = function(el) {
		$(el).off(".hotBinding");
	};

	// binding.getType = function() {
	//   return "shinyjsexamples.hot";
	// };

	Shiny.inputBindings.register(binding);
})();
=======




    // BINDINGS

    var dsHotBinding = new Shiny.InputBinding();

    dsHotBinding.find = function(scope) {
        // console.log("FIND: ", $(scope).find(".hot"));
        return $(scope).find(".hot");
    };

    dsHotBinding.initialize = function(el) {

        // console.log("INIT: ", el.id);
        // // var elid = document.getElementsByClassName('hot');
        var elid = $(el);
        console.log("i", elid);
        // https://jsfiddle.net/04r5cgsb/1/ add comments to cells
        var settings = {};
        settings.maxRows = 50;
        var rowsIdx = Array.from(new Array(settings.maxRows), (val, index) => index + 1);
        settings.availableCtypes = ["Numeric", "Categoric", "Date"];

        // var hotElement = document.querySelector('#hot');
        // var hotElement = elid[0];
        var params = formatDataParams(el);
        console.log("params",params);
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
                if (ctype == "Numeric") {
                    this.validator = valiNumeric;
                }
                if (ctype == "Categoric") {
                    this.validator = valiCategoric;
                }
            }
        };
        console.log("elid",el.id)
        var hot = new Handsontable(el, hotSettings);
        console.log("HOT",hot);
        hot.validateCells();
        window[[el.id]] = hot;

        // // hot.getPlugin('autoColumnSize');

        // document.addEventListener('mousemove', function(event) {
        //     hot.updateSettings({
        //         width: $('.hot').parent().width()
        //     });
        // });

        // updateChooser(el);
    };

    dsHotBinding.getValue = function(el) {
        var hot = window[[el.id]];
        console.log("getHot",window[[el.id]]);
        return JSON.stringify(parseHotInput(hot.getData()));
    };

    dsHotBinding.setValue = function(el, value) {
        // TODO: implement
    };

    dsHotBinding.subscribe = function(el, callback) {
        // document.addEventListener('mousemove', function(event) {
        //     var hot = window[[el.id]];
        //     hot.updateSettings({
        //         width: $(el).parent().width()
        //     });
        //     callback();
        // });
        $(el).on("change.hotBinding", function(e) {
            callback();
        });

    };

    dsHotBinding.unsubscribe = function(el) {
        $(el).off(".hotBinding");
    };

    dsHotBinding.getType = function() {
      return "dsHotBinding";
    };

    Shiny.inputBindings.register(dsHotBinding);



})();
>>>>>>> 5d2da06a3ceac5ddc788feee6e1b8b422852fc0c
