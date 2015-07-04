var Hapi = require('hapi'),
    Path = require('path'),
    server = new Hapi.Server();

server.connection({
  port: process.env.PORT
});

server.views({
  engines: {
    html: require('handlebars')
  },
  path: Path.join(__dirname, "views")
});

server.route(require('./js/routes.js'));

server.start(function () {
  server.log('Server running at: ' + server.info.uri + "!");
});

module.exports = server;