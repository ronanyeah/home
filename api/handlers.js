'use strict';

var redis = require('./redis.js');

function registerVisit(id, request) {
  function maliciousIdCheck(id) {
    return id.length !== 10 || id.match(/[^A-Za-z0-9]/);
  }

  if (maliciousIdCheck(id)) {
    return;
  }

  var analytics = {
    id: id,
    ip: request.headers['x-forwarded-for'] || request.info.remoteAddress,
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
    reply.file('./public/views/index.html');
  },

  analytics: function(request, reply) {
    reply.file('./public/views/analytics.html');
  },

  pullAnalytics: function(request, reply) {
    redis().pullAnalytics(function(analyticsArray) {
      reply(JSON.stringify(analyticsArray));
    });
  },

  newUser: function(request, reply) {
    registerVisit(request.payload.cookie, request);
    reply();
  },

  setLocation: function(request, reply) {
    var id;
    if(request.headers.cookie) {
      if(request.headers.cookie.indexOf('userId=') > -1) {
        id = request.headers.cookie.split('userId=')[1].substr(0, 10);
      }
    }
    redis().setLocation(id, request.payload.coordinate);
    reply();
  },

  addAnalytics: function(request, reply) {
    // redis.startClient(redis.addData, analytics);
  }

};