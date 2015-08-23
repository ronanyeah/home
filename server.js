var Hapi = require('hapi'),
    server = new Hapi.Server(),
    goodAnalytics = require('good'),
    analyticsOptions = {
      opsInterval: 1000,
      reporters:
      [
        {
          reporter: require('good-http'),
          events: { request: '*' },
          config: {
            endpoint : 'http://localhost:8000/addAnalytics',
            threshold: 0
          }
        }
      ]
    };

server.connection({
  port: process.env.PORT
});

server.route(require('./javascript/api/routes.js'));
 
server.register(
  {
    register: goodAnalytics,
    options: analyticsOptions
  },
  function() {
    server.start(function() {
      console.log('Server running at: ' + server.info.uri + '!');
    });
  }
);

module.exports = server;