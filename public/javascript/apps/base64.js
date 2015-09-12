'use strict';

module.exports = {

  encode: function (str) {
    var charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',
        result = [],
        curr, //current working byte
        prev, //previous byte
        bytePosition;

    if (str.length === 0) {
      return 'ENTER SOME TEXT!';
    } else if (/([^\u0000-\u00ff])/.test(str)) {
      return 'ASCII CHARACTERS ONLY!';
    }

    for(var i = 0; i < str.length; i++) {
      curr = str.charCodeAt(i);
      bytePosition = i % 3; //base64 is calculated in groups of 3 bytes

      switch(bytePosition){
        case 0: //first byte
          result.push(charset.charAt(curr >> 2));
          break;

        case 1: //second byte
          result.push(charset.charAt((prev & 3) << 4 | (curr >> 4)));
          break;

        case 2: //third byte
          result.push(charset.charAt((prev & 0x0f) << 2 | (curr >> 6)));
          result.push(charset.charAt(curr & 0x3f));
          break;
      }

      prev = curr;
    }

    //padding
    if (bytePosition === 0) {
      result.push(charset.charAt((prev & 3) << 4));
      result.push("==");
      return result.join('');
    } else if (bytePosition === 1) {
      result.push(charset.charAt((prev & 0x0f) << 2));
      result.push("=");
      return result.join('');
    } else {
      return result.join('');
    }

  },

  decode: function (str) {
    var charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',
        result = [],
        prev,
        curr,
        bytePosition;

    str = str.replace(/\s+/g, ""); //removes whitespace

    if (0 === str.length) {
      return 'ENTER SOME TEXT!';
    } else if (!/^[a-z0-9\+\/\s]+\={0,2}$/i.test(str) || str.length % 4 > 0) {
      return 'ENTER A VALID STRING!';
    }

    str = str.replace(/=/g, "");

    for (var i = 0; i < str.length; i++) {
      curr = charset.indexOf(str.charAt(i));
      bytePosition = i % 4;
      switch (bytePosition) {
        case 0:
          break;
        case 1:
          result.push(String.fromCharCode(prev << 2 | curr >> 4));
          break;
        case 2:
          result.push(String.fromCharCode((15 & prev) << 4 | curr >> 2));
          break;
        case 3:
          result.push(String.fromCharCode((3 & prev) << 6 | curr));
      }
      prev = curr;
    }
    
    return result.join("");
  }

};