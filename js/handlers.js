var redis = require('./redis.js');

function addNewUser (id, request) {
  var analytics = {
    id: id,
    ip: request.headers['x-forwarded-for']  || request.info.remoteAddress,
    visits: 1,
    lastVisited: new Date().getTime()
  };
  redis.startRedisClient(analytics);
}

module.exports = {

  home: function(request, reply) {
    // request.log(); // triggers the good-http log on server.js to the /addAnalytics endpoint
    if(request.headers.cookie) {
      addNewUser(request.headers.cookie.split('=')[1], request);
    }
    reply.view('index.html');
  },

  analytics: function(request, reply) {
    reply.view('analytics.html');
  },


  newUser: function(request, reply) {
    addNewUser(request.query.userId, request);
  },

  addAnalytics: function(request, reply) {
    // redis.startClient(redis.addData, analytics);
  }

};