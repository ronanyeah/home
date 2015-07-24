var redis = require('./redis.js');

function registerVisit(id, request) {
  var analytics = {
    id: id,
    ip: request.headers['x-forwarded-for']  || request.info.remoteAddress,
    lastVisited: new Date().getTime(),
    location: 0,
    visits: 1
  };
  redis().checkDatabaseForUser(analytics);
}

module.exports = {

  home: function(request, reply) {
    // request.log(); // triggers the good-http log on server.js to the /addAnalytics endpoint
    if(request.headers.cookie) {
      if(request.headers.cookie.indexOf('userId=') > -1) {
        registerVisit(request.headers.cookie.split('userId=')[1].substr(0, 10), request);
      }
    }
    reply.file('./views/index.html');
  },

  analytics: function(request, reply) {
    reply.file('./views/analytics.html');
  },

  pullAnalytics: function(request, reply) {
    redis().pullAnalytics(function(analyticsArray) {
      reply(JSON.stringify(analyticsArray));
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