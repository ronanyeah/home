var redis = require('./redis.js');

function addNewUser (id) {
  var analytics = {
    id: id,
    visits: 1,
    time: new Date().getTime()
  };
  // redis.startRedisClient(analytics);
}

module.exports = {

  home: function(request, reply) {
    // request.log(); // triggers the good-http log on the server to the /analytics endpoint
    console.log(request.id);
    console.log(request.info.remoteAddress);
    console.log(request.info.host);
    console.log(request.info.hostname);
    console.log(request.connection.info);
    console.log(request.state.userId);
    if(request.headers.cookie) {
      addNewUser(request.headers.cookie.split('=')[1]);
    }
    reply.view('index.html');
  },

  newUser: function(request, reply) {
    addNewUser(request.query.userId);
  },

  analytics: function(request, reply) {
    // redis.startClient(redis.addData, analytics);
  }

};