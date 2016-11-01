/*jslint node:true */
/*jshint esnext:true */
/*jshint unused:false*/

var words = require('./ki.json');
var i;

Object.keys(words).map(current => {
    console.log(words[current]);
});
