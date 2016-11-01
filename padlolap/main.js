/*jslint node:true */
/*jshint esnext:true */
/*jshint unused:false*/

var fs       = require('fs'),
    through  = require('through2'),
    finname  = '/Users/atus/Documents/NNG/padlolap/num.txt',
    foutname = '/Users/atus/Documents/NNG/padlolap/out.txt';

function halver() {

    var rS = fs.createReadStream (finname, {highWaterMark:1}),//open file stream
        wS = fs.createWriteStream(foutname),
        stream = through(write, end),//create transform stream
        r = 0;//remainder

    rS.on('open', () => {rS.pipe(stream); stream.pipe(wS);});
    //pipe out through transform stream

    function write(buffer, enc, next) {
        var res;
        buffer = parseInt(buffer.toString());

        if (isWhole(buffer/2)) {res = buffer/2     + r; r = 0;}
        else                   {res = buffer/2-0.5 + r; r = 5;}
        this.push(res.toString());
        next();

        function isWhole(n) {return n%1===0;}
    }

    function end(done){done();}
}

halver();


