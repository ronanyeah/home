var redis = function() {
  "use strict";

  function sanitiseText (text) {
    //replace non AZaz09 characters with #
  }

  var client;

  var redisModule = require('redis');
  var url = require('url');

  var redisURL = url.parse(process.env.REDIS_URL);

  client = redisModule.createClient(redisURL.port, redisURL.hostname);

  client.auth(redisURL.auth.split(":")[1]);

  console.log(client.address);

  return {

    checkDatabaseForUser: function (analytics) {
      client.select(0, function() {
        client.exists(analytics.id, function (err, data) {
          if (err) {
            console.log(err);
          } else {
            if(data) {
              redis().increaseViews(analytics);
            } else {
              redis().addNewUser(analytics);
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
    },

    pullAnalytics: function (db, callback) {
      var fileLoad = [];
      var dbKeys =[];

      var redisCallback = function(err, data) {
        if(err) {
          console.log(err);
        } else {
          fileLoad.push(data);
          if(fileLoad.length === dbKeys.length) {
            client.quit(function(err, data) {
              if (err) {
                console.log(err);
              } else {
                callback(fileLoad);
                // console.log('client quit:', data);
              }
            });
          }
        }
      };

      var scan = function(x) {
        client.scan(x, function(err, data) {
          if(err) {
            console.log(err);
          } else {
            dbKeys = dbKeys.concat(data[1]);
            if(data[0] === "0") {
              for(var i = 0; i < dbKeys.length; i++) {
                client.hgetall(dbKeys[i], redisCallback);
              }
            } else {
              scan(data[0]);
            }
          }
        });
      };

      client.select(db, function() {
        scan(0);
      });
    }

  };

};

module.exports = redis;