var hapi = require('hapi'),
    path = require('path'),
    server = new hapi.Server();

server.connection({ port: process.env.PORT});

server.views({
  engines: {
    html: require('handlebars')
  },
  path: path.join(__dirname, "views")
});

server.route(require('./js/routes.js'));

server.start(function () {
  server.log('Server running at: ' + server.info.uri);
});

module.exports = server;