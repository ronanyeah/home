module.exports = {

  userCookie: function () {
    var userId = "";
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for(var i = 0; i < 10; i++) {
      userId += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    return "userId=" + userId;
  },

  expireCookie: function () {
    var userId = "";
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for(var i = 0; i < 10; i++) {
      userId += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    var expires = new Date().setFullYear(new Date().getFullYear() + 1);

    return "expires=" + new Date(expires).toGMTString();
  },

  cookieCheck: function () {

    if(!document.cookie) {
      document.cookie = this.userCookie() + ';' + this.expireCookie() + ';';
      console.log(document.cookie);
    } else {
      console.log(document.cookie);
    }

  }

};