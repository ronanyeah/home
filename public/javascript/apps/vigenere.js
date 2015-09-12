'use strict';

module.exports = {
  
  encode: function (message, codeword) {
    var abc = "abcdefghijklmnopqrstuvwxyz",
        out = "",
        ciph,
        x,
        y;

    for (var i = 0; i < message.length; i++) {
      if (abc.indexOf(message[i]) === -1) {
        out += message[i];
      } else {
        ciph = codeword[i % codeword.length];
        x = abc.indexOf(ciph);
        y = abc.indexOf(message[i]);
        out += abc[(x + y) % abc.length];
      }
    }

    return out;
  },

  decode: function (message, codeword) {
    var abc = "abcdefghijklmnopqrstuvwxyz",
        out = "",
        ciph,
        x,
        y;

    for (var i = 0; i < message.length; i++) {
      if (abc.indexOf(message[i]) === -1) {
        out += message[i];
      } else {
        ciph = codeword[i % codeword.length];
        x = abc.indexOf(ciph);
        y = abc.indexOf(message[i]);
        out += abc[(y - x + abc.length) % abc.length];
      }
    }

    return out;
  }

};