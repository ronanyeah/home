var fs = require('fs');

function handlers() {
  "use strict";
  return {
    generic: function(req, res) {
      fs.readFile(__dirname + req.url, function(err, data){
        if (err){
          res.end();
        }
        else {
          var ext = req.url.split('.')[1];
          res.writeHead(200, {'Content-Type' : 'text/' + ext});
          res.end(data);
        }
      });
    }
  };
}

module.exports = handlers;