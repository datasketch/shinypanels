

var elid = document.getElementsByClassName('hot');

console.log(document.getElementsByClassName('hot')
  // .getAttribute('data-dic')
  );


// var dataDic = JSON.parse(document.getElementById('hot').getAttribute('data-dic'));
// var dataInput = JSON.parse(document.getElementById('hot').getAttribute('data-table'));
// var hotOpts = JSON.parse(document.getElementById('hot').getAttribute('data-hotOpts'));
var dataDic = JSON.parse(elid[0].getAttribute('data-dic'));
var dataInput = JSON.parse(elid[0].getAttribute('data-table'));
var hotOpts = JSON.parse(elid[0].getAttribute('data-hotOpts'));

console.log(dataInput); 

var dataHeaders = [];
dataHeaders[0] = dataDic.reduce(function (final, item) {
  item.data = item.id;
  final[item.data] = item.ctype;
  return final
}, {});
dataHeaders[1] = dataDic.reduce(function (final, item) {
  item.data = item.id;
  final[item.data] = item.label;
  return final
}, {});

var dataObject = dataHeaders.concat(dataInput);
console.log("dataObject", dataObject)

// More renderers https://handsontable.com/blog/articles/getting-started-with-cell-renderers
ctypeRenderer = function(instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.DropdownRenderer.apply(this, arguments);
  td.style.backgroundColor = '#0E0329';
  td.style.fontWeight = 'italic';
  td.style.color = '#A6CEDE';
  td.className = 'tableCtype'

};
// https://docs.handsontable.com/5.0.1/tutorial-cell-types.html
headRenderer = function(instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments);
  td.style.backgroundColor = '#DDD';
  td.style.fontWeight = 'italic';
  td.style.color = '#B70F7F';
  td.className = 'tableHeader';
};

invalidRenderer = function(instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments);
  // td.style.backgroundColor = '#F00!important';
  td.className = 'invalidCell';
};

// Validator

// var valiNumeric = /[0-9]/g;
var valiNumeric = function(value,callback){
    if (/[0-9]/g.test(value)) {
      callback(true);
    }
    else {
      callback(false);
    }
}
var valiCategoric = function(value,callback){
    if (/[a-z]/g.test(value)) {
      callback(true);
    }
    else {
      callback(false);
    }
}
var valiDate = function(value,callback){
    if (/^(?:[1-9]\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)T(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(?:Z|[+-][01]\d:[0-5]\d)$/.test(value)) {
      callback(true);
    }
    else {
      callback(false);
    }
}


Handsontable.validators.registerValidator('valiNumeric', valiNumeric);
Handsontable.validators.registerValidator('valiCategoric', valiCategoric);
Handsontable.validators.registerValidator('valiDate', valiDate);



// https://jsfiddle.net/04r5cgsb/1/ add comments to cells

var settings = {};
settings.maxRows = 50;
var rowsIdx = Array.from(new Array(settings.maxRows),(val,index)=>index+1);
settings.availableCtypes = ["Numeric","Categoric","Date"];

// var hotElement = document.querySelector('#hot');
var hotElement = elid[0];

var hotElementContainer = hotElement.parentNode;
var hotSettings = {
  data: dataObject,
  columns: dataDic,
  stretchH: 'all',
  width: hotOpts.width,
  autoWrapRow: true,
  height: hotOpts.height,
  maxRows: hotOpts.maxRows + 2,
  rowHeaders: [null,null].concat(rowsIdx),
  colHeaders: true,
  manualRowMove: hotOpts.manualRowMove,
  manualColumnMove: hotOpts.manualColumnMove,
  // invalidCellClassName: 'highlight--error',
  cells: function (row, col, prop) {
    // console.log(this);
     if (row === 0){
      this.renderer = ctypeRenderer;
      this.type = 'dropdown';
      this.source = settings.availableCtypes;
      this.validator = null;
      return(this)
     }
     if (row === 1) {
      // console.log(row)
      this.renderer = headRenderer;
      this.validator = null;
      return(this)
     }
    // if (col === 0) {
    //   this.validator = /[0-9]/g;
    //   this.allowInvalid = true;
    //  }
     //Get current ctype
     var ctype = this.instance.getDataAtCell(0,col);
     if(ctype == "Numeric"){
       this.validator = valiNumeric;
     }
     if(ctype == "Categoric"){
        this.validator = valiCategoric;
     }
     // if(ctype == "Date"){
     //    this.validator = valiDate;
     // }
     // console.log(!this.valid, this.instance.getDataAtCell(row,col),ctype );
     // if(this.valid === false){
     //    this.renderer = invalidRenderer;
     // }

   }
};
var hot = new Handsontable(hotElement, hotSettings);
hot.validateCells();





(function() {

// $(document).on("change", ".hot select", function() {
//     updateChooser($(this).parents(".hot"));
// });

// $(document).on("click", ".hot .right-arrow", function() {
//     move($(this).parents(".hot"), ".left", ".right");
// });

// $(document).on("click", ".hot .left-arrow", function() {
//     move($(this).parents(".hot"), ".right", ".left");
// });

// $(document).on("dblclick", ".hot select.left", function() {
//     move($(this).parents(".hot"), ".left", ".right");
// });

// $(document).on("dblclick", ".hot select.right", function() {
//     move($(this).parents(".hot"), ".right", ".left");
// });




if (typeof Shiny != "undefined") {
  console.log("Shiny defined");

  var binding = new Shiny.InputBinding();

  binding.find = function(scope) {
    console.log("FIND: ",$(scope).find(".hot"));
    return $(scope).find(".hot");
  };

  // binding.initialize = function(el) {
  //   updateChooser(el);
  // };

  binding.getValue = function(el) {
    console.log("GET: ", hot.getData());
    var ell = el;
    return {
      data:hot.getData()
    }
  };

  binding.setValue = function(el, value) {
    // TODO: implement
  };

  binding.subscribe = function(el, callback) {
    $(el).on("change.hotBinding", function(e) {
      callback();
    });
  };

  binding.unsubscribe = function(el) {
    $(el).off(".hotBinding");
  };

  // binding.getType = function() {
  //   return "shinyjsexamples.hot";
  // };

  Shiny.inputBindings.register(binding);


}



})();


