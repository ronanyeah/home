var $ = require('jquery');

module.exports = {

  userCookie: function () {
    var userId = '';
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    for(var i = 0; i < 10; i++) {
      userId += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    return userId;
  },

  expireCookie: function () {
    var expires = new Date().setFullYear(new Date().getFullYear() + 1);

    return new Date(expires).toGMTString();
  },

  cookieCheck: function () {

    if(!document.cookie) {
      var cookie = this.userCookie();
      document.cookie = 'userId=' + cookie + ';expires=' + this.expireCookie();

      //from fac website
      // var xhr = new XMLHttpRequest();
      // xhr.onreadstatechange = function () {
        
      //  console.log("OK");
      // }

      // xhr.open("POST", apiEmail, true);
      //   xhr.withCredentials = true;
      // xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      // xhr.send(JSON.stringify(postDate));

      $.ajax({
        type: "POST",
        url: '/newUser',
        data: {cookie: cookie},
      });

    } else {
      console.log('welcome back');
    }

  }

};