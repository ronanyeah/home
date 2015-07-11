// $ = require('jquery');

window.app = angular.module('myApp', []);

var sortClaps = function (a, b) {
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
  $http.get('/pullAnalytics').success(function(data) {
    var arr = [];
    data = data.sort(sortClaps);
    data.forEach(function (x) {
      x.lastVisited = new Date(Number(x.lastVisited)).toGMTString();
      if((document.cookie).indexOf(x.id) > -1) {
        $scope.you = x;
      } else {
        arr.push(x);
      }
    });
    $scope.users = arr;
  });
});