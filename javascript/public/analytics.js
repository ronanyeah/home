var angular = require('angular'),
    $ = require('jquery');  

function sortObjects(a, b) {
  var aTime = Number(a.lastVisited);
  var bTime = Number(b.lastVisited);
  if (aTime < bTime) {
    return 1;
  } else if (aTime > bTime) {
    return -1;
  } else {
    return 0;
  }
}

function getUserIdFromCookie() {
  if (document.cookie) {
    if (document.cookie.indexOf('userId') !== -1) {
      return document.cookie.split('userId=')[1].substr(0, 10);
    }
  }
  return null;
}

$('#homeButton').click(function() {
  window.location = "/";
});

var app = angular.module('analyticsApp', []);

app.controller('dbCtrl', function($scope, $http) {
  $http.get('/pullAnalytics').success(function(analyticsObjects) {
    var pastVistors = [];
    analyticsObjects = analyticsObjects.sort(sortObjects);
    analyticsObjects.forEach(function(x) {
      x.lastVisited = new Date(Number(x.lastVisited)).toLocaleString();
      var cookie = getUserIdFromCookie();
      if (x.id == cookie) {
        $scope.you = x;
      } else {
        pastVistors.push(x);
      }
    });
    $scope.users = pastVistors;
  });
});
