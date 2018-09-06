
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


function formatDataParams(el){
  var dataDic = JSON.parse(el.getAttribute('data-dic'));
  var dataInput = JSON.parse(el.getAttribute('data-table'));
  var hotOpts = JSON.parse(el.getAttribute('data-hotOpts'));
  console.log("data-hotOpts",hotOpts); 
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
  return{
    dataDic: dataDic,
    dataObject: dataObject,
    hotOpts: hotOpts
  }
}


function parseHotInput(d) {
    var letters = "abcdefghijklmnopqrstuvwxyz".split("");
    var ncols = d[0].length;
    var letter_ids = letters.slice(0, ncols);
    // console.log(letters.slice(0,ncols));
    var dic = d.slice(0, 2).concat([letter_ids]);
    var data = d.slice(2);
    // console.log("dic", dic)
    // console.log("data", data)
    function transpose(matrix) {
        return matrix[0].map((col, i) => matrix.map(row => row[i]));
    }

    function dicToDataframe(arr) {
        return arrayToObj(transpose(arr), ["ctype", "label", "id"])
    }

    function arrayToObj(arr, keys) {
        return arr.map(function(x) {
            var obj = x.reduce(function(acc, cur, i) {
                // console.log("acc: ", acc, "\ncur: ", cur, "\ni: ",i);
                acc[keys[i]] = cur;
                return acc;
            }, {});
            return obj;
        });
    }
    return{
      data: arrayToObj(data, letter_ids),
      dic: dicToDataframe(dic)
    }

}


