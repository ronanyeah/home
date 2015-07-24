$ = require('jquery');

window.app = angular.module('myApp', []);

var sortObjects = function (a, b) {
  var aTime = Number(a.lastVisited);
  var bTime = Number(b.lastVisited);
  if (aTime < bTime) {
    return 1;
  }
  if (aTime > bTime) {
    return -1;
  }
  return 0;
};

$('#homeButton').click(function(){
  window.location = "/";
});

app.controller('dbCtrl', function ($scope, $http) {
  $http.get('/pullAnalytics').success(function(analyticsObjects) {
    var arr = [];
    analyticsObjects = analyticsObjects.sort(sortObjects);
    analyticsObjects.forEach(function(x) {
      x.lastVisited = new Date(Number(x.lastVisited)).toLocaleString();
      if(document.cookie.split("=")[1] === x.id) {
        $scope.you = x;
      } else {
        arr.push(x);
      }
    });
    $scope.users = arr;
  });
});