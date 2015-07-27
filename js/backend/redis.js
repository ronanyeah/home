var redis = function() {
  'use strict';

  var redisModule = require('redis'),
      url = require('url'),
      redisURL = url.parse(process.env.REDIS_URL),
      client;

  client = redisModule.createClient(redisURL.port, redisURL.hostname);
  client.auth(redisURL.auth.split(':')[1]);

  client.on('error', function(err) {
    console.log('Redis Error: ' + err);
  });

  return {

    checkDatabaseForUser: function(analytics) {
      client.select(0, function() {
        client.exists(analytics.id, function(err, exists) {
          if(exists) {
            increaseViews(analytics);
          } else {
            addNewUser(analytics);
          }
        });
      });

      function increaseViews(analytics) {
        client.hget(analytics.id, 'visits', function(err, numberOfVisits) {
          client.hmset(analytics.id, 'visits', Number(numberOfVisits) + 1, 'ip', analytics.ip, 'lastVisited', analytics.lastVisited, function(err, data) {
            client.quit();
          });
        });
      }

      function addNewUser(analytics) {
        client.hmset(analytics.id, analytics, function(err, data) {
          client.quit();
        });
      }
    },

    pullAnalytics: function(returnAnalytics) {
      var analyticsArray = [],
          databaseKeys = [],
          counter;

      client.select(0, function() {
        scanRedis(0);
      });

      function scanRedis(cursorNumber) {
        client.scan(cursorNumber, function(err, scanResults) {
          databaseKeys = databaseKeys.concat(scanResults[1]);

          if(scanResults[0] === '0') {
            counter = databaseKeys.length;

            databaseKeys.forEach(function(key) {
              client.hgetall(key, addAnalyticsToArray);
            });
          } else {
            scanRedis(scanResults[0]);
          }
        });
      }

      function addAnalyticsToArray(err, analyticsObject) {
        analyticsArray.push(analyticsObject);

        if(analyticsArray.length === counter) {
          client.quit();

          returnAnalytics(analyticsArray);
        }
      }

    },

    setLocation: function(id, coordinate) {
      client.hset(id, 'location', coordinate, function(err, data) {
        client.quit();
      });
    }

  };

};

module.exports = redis;