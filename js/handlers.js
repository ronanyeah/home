var redis = require('./redis.js');

module.exports = {

  home: function(request, reply) {
    // request.log(); // triggers the good-http log on the server to the /analytics endpoint
    if(request.headers.cookie) {
      var analytics = {
        id: request.headers.cookie.split('=')[1],
        visits: 2,
        time: new Date().getTime(),
        info: request.info
      };
      redis.startRedisClient(analytics);
    }
    reply.view('index.html');
  },

  analytics: function(request, reply) {
    // redis.startClient(redis.addData, analytics);
  }

};