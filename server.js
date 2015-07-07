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
  reporters: [
    {
      reporter: require('good-console'),
      events: { log: '*', response: '*' }
    },

    // {
    //   register: Good,
    //   options: {
    //     reporters: [{
    //       reporter: require('good-http'),
    //       events: { request: '*' },
    //       config: {
    //         endpoint : 'http://localhost:8000/analytics',
    //         threshold: 0
    //       }
    //     }]
    //   }
    // }

    // {
    //   reporter: require('good-file'),
    //   events: { ops: '*' },
    //   config: './awesome_log'
    // },

    // {
    //   reporter: 'good-http',
    //   events: { error: '*' },
    //   config: {
    //     endpoint: 'http://prod.logs:3000',
    //     wreck: {
    //       headers: { 'x-api-key' : 12345 }
    //     }
    //   }
    // }
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