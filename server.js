var routing = require('./js/routing.js');
var http = require("http");

http.createServer(routing.router);

http.listen(process.env.PORT || 8000);