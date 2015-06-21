var handlers = require('./js/handlers.js');
var fs = require('fs');

function routing() {
  "use strict";
  return {
    router: function (req, res){
      if (req.url.length === 1) {
        res.writeHead(200, {"Content-Type": "text/html"});
        res.end(fs.readFileSync(__dirname + '/index.html').toString());
      }

      else {
        var route = req.method + " " + req.url;
        var endRoute = handlers[route];
        if (endRoute) {
          endRoute(req, res);
        } else {
          handlers.generic(req, res);
        }
      }
    }
  };
}

module.exports = routing;