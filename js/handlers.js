var redis = require('./redis.js');

function registerVisit(id, request) {
  var analytics = {
    id: id,
    ip: request.headers['x-forwarded-for']  || request.info.remoteAddress,
    visits: 1,
    lastVisited: new Date().getTime()
  };
  redis().checkDatabaseForUser(analytics);
}

module.exports = {

  home: function(request, reply) {
    // request.log(); // triggers the good-http log on server.js to the /addAnalytics endpoint
    if(request.headers.cookie) {
      registerVisit(request.headers.cookie.split('=')[1], request);
    }
    reply.view('index.html');
  },

  analytics: function(request, reply) {
    reply.view('analytics.html');
  },

  pullAnalytics: function(request, reply) {
    redis().pullAnalytics(0, function(data) {
      reply(JSON.stringify(data));
    });
  },

  newUser: function(request, reply) {
    registerVisit(request.payload.cookie, request);
    reply(true);
  },

  addAnalytics: function(request, reply) {
    // redis.startClient(redis.addData, analytics);
  }

};