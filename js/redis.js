var client;

function sanitiseText (text) {
  //replace non AZaz09 characters with #
}

var redis = {

  startRedisClient: function (analytics, callback) {
    var redisModule = require('redis');
    var url = require('url');

    var redisURL = url.parse(process.env.REDIS_URL);

    client = redisModule.createClient(redisURL.port, redisURL.hostname);

    client.auth(redisURL.auth.split(":")[1]);

    redis.checkDatabaseForUser(analytics);
  },

  checkDatabaseForUser: function (analytics) {
    client.select(0, function() {
      client.exists(analytics.id, function (err, data) {
        if (err) {
          console.log(err);
        } else {
          if(data) {
            redis.increaseViews(analytics);
          } else {
            redis.addNewUser(analytics);
          }
        }
      });
    });
  },

  increaseViews: function (analytics) {
    client.select(0, function() {
      client.hget(analytics.id, "visits", function (err, data) {
        if (err) {
          console.log(err);
        } else {
          client.hmset(analytics.id, "visits", Number(data) + 1, "ip", analytics.ip, "lastVisited", analytics.lastVisited, function(err, data) {
            if (err) {
              console.log(err);
            } else {
              client.quit(function(err, data) {
                if (err) {
                  console.log(err);
                } else {
                  // console.log('client quit:', data);
                }
              });
            }
          });
        }
      });
    });
  },

  addNewUser: function (analytics) {
    client.select(0, function() {
      client.hmset(analytics.id, analytics, function (err, data) {
        if (err) {
          console.log(err);
        } else {
          client.quit(function(err, data) {
            if (err) {
              console.log(err);
            } else {
              // console.log('client quit:', data);
            }
          });
        }
      });
    });
  }

};

module.exports = redis;
