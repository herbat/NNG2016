/*jslint node:true */
/*jshint esnext:true */
/*jshint unused:false*/

var fs       = require('fs'),
    through  = require('through2'),
    finname  = '/Users/atus/Documents/NNG/padlolap/num.txt',
    foutname = '/Users/atus/Documents/NNG/padlolap/out.txt';

function half(n) {

    var rS     = fs.createReadStream(finname, {highWaterMark:1}),//open file stream
        wS     = fs.createWriteStream(foutname),//open outfile stream
        stream = through(write, end),//create transform stream
        r      = 0,//remainder
        count  = 0;//counter to do exactly the desired amount of digits

    rS.on('open', () => {rS.pipe(stream); stream.pipe(wS);});

    //pipe out through transform stream

    function write(buffer, enc, next) {
        function isWhole(n) {return n%1===0;}

        var res;
        buffer = parseInt(buffer.toString());//buf to int

        //division by 2
        if (isWhole(buffer/2)) {res = buffer/2     + r; r = 0;}
        else                   {res = buffer/2-0.5 + r; r = 5;}
        this.push(res.toString());//push to outstream

        //close on too many digits
        count++;
        if(count > n) rS.close();
        next();

    }

    function padZeroes(n){
        for(var i = 0; i < n-1; i++){
            wS.write(0);
        }
        wS.write(1);
    }

    function end(done){padZeroes(n); done();}
}

half(9);


