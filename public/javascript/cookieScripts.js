'use strict';

var $ = require('jquery');

function setExpiryDate() {
  var expires = new Date().setFullYear(new Date().getFullYear() + 1);

  return new Date(expires).toGMTString();
}

function maliciousCookie() {
  var userId = document.cookie.split('userId=')[1].substr(0, 10);
  return userId.match(/[^A-Za-z0-9]/);
}

module.exports = {

  createUserCookie: function() {
    var userId = '';
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    for(var i = 0; i < 10; i++) {
      userId += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    document.cookie = 'userId=' + userId + ';expires=' + setExpiryDate();

    $.ajax({
      type: 'POST',
      url: '/newUser',
      data: {cookie: userId}
    });
  },

  cookieCheck: function() {
    if (document.cookie) {
      if (document.cookie.indexOf('userId=') === -1) {
        this.createUserCookie();
      } else if (maliciousCookie()) {
        this.createUserCookie();
      } else {
        console.log('Welcome back!');
      }
    } else {
      this.createUserCookie();
    }
  }

};