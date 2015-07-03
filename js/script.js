//$lab:coverage:off$
// if (!module) {
//  var module = {};
// }
//$lab:coverage:on$

/*
different script file for each kata?
modularise entire file
*/

var scripts = {

  base64Encode: function (str) {
    var result = [],
        curr, //current working byte
        prev, //previous byte
        charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',
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

  base64Decode: function (str) {
    var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        out = [],
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
          out.push(String.fromCharCode(prev << 2 | curr >> 4));
          break;
        case 2:
          out.push(String.fromCharCode((15 & prev) << 4 | curr >> 2));
          break;
        case 3:
          out.push(String.fromCharCode((3 & prev) << 6 | curr));
      }
      prev = curr;
    }
    
    return out.join("");
  },

  fibonacci: function (num) {
    var out = [],
        control = [0, 1];

    if (1 > num || Number(num) !== num) {
      return "Invalid input!";
    }

    for (var i = 0; out.length < num; i++) {
      out.push(control[0]);
      control.push(control[0] + control[1]);
      control = control.slice(1);
    }

    return out.join(", ");
  },

  vigEncode: function (message, codeword) {
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

  vigDecode: function (message, codeword) {
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
  },

  haversine: function (values, cart) {
    var earth = 6371,
        toRads = function (x) { //convert to Radians
          return x * Math.PI / 180;
        };

    function checkValidity (value) {
      if(isNaN(value) || value < 0) { //if invalid or less than zero
        return 0;
      } else {
        return value;
      }
    }
    
    for(var j = 0; j < 12; j++) { //change inputs to numbers or zero
      values[j] = checkValidity(parseInt(values[j], 10));
    }
    
    for(var i = 0; i < 11; i += 3) { //fix out of range values
      if(values[i] === 180) {
        values[i + 1] = 0;
        values[i + 2] = 0;
      }
      if(values[i] > 180) {
        values[i] = 0;
      }
      if(values[i + 1] > 60) {
        values[i + 1] = 0;
      }
      if(values[i + 2] > 60) {
        values[i + 2] = 0;
      }
    }
    
    var out = [];
    //change to decimal degrees
    out[0] = values[0] + values[1] / 60 + values[2] / 3600;
    out[1] = values[3] + values[4] / 60 + values[5] / 3600;
    out[2] = values[6] + values[7] / 60 + values[8] / 3600;
    out[3] = values[9] + values[10] / 60 + values[11] / 3600;
    
    if(cart[0] === 'S') {
      out[0] *= -1;
    }
    if(cart[1] === 'W') {
      out[1] *= -1;
    }
    if(cart[2] === 'S') {
      out[2] *= -1;
    }
    if(cart[3] === 'W') {
      out[3] *= -1;
    }
    
    var lon1 = out[0],
        lat1 = out[1],
        lon2 = out[2],
        lat2 = out[3];
        
    var rLat1 = toRads(lon1),
        rLat2 = toRads(lon2),
        dLat = toRads(lon2 - lon1),
        dLon = toRads(lat2 - lat1),
        a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(rLat1) * Math.cos(rLat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2),
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return Math.floor(earth * c) + "km";
  }
  
};

module.exports = scripts;