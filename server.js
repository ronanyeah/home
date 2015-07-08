var Hapi = require("hapi"),
    Path = require("path"),
    server = new Hapi.Server();

server.connection({
  port: process.env.PORT
});

server.views({
  engines: {
    html: require("handlebars")
  },
  path: Path.join(__dirname, "views")
});

server.route(require("./js/routes.js"));

var analyticsOptions = {
  opsInterval: 1000,
  reporters:
  [
    {
      reporter: require('good-http'),
      events: { request: '*' },
      config: {
        endpoint : 'http://localhost:8000/analytics',
        threshold: 0
      }
    }
  ]
};
 
server.register(
  {
    register: require('good'),
    options: analyticsOptions
  },
  function () {
    server.start(function () {
      console.log("Server running at: " + server.info.uri + "!");
    });
  }
);

module.exports = server;