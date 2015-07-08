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
      var cookie = 'userId=' + this.userCookie();
      document.cookie = cookie + ';expires=' + this.expireCookie();
      var xhr = new XMLHttpRequest();
      xhr.open('POST', '/newUser?' + cookie);
      xhr.send();
    } else {
      console.log('welcome back');
    }

  }

};