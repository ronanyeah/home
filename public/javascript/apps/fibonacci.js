'use strict';

module.exports = {

  fibonacci: function (num) {
    var out = [],
        control = [0, 1];

    num = Number(num);

    if (1 > num || isNaN(num)) {
      return "Invalid input!";
    }

    for (var i = 0; out.length < num; i++) {
      out.push(control[0]);
      control.push(control[0] + control[1]);
      control = control.slice(1);

      if (control[1] === Infinity) {
        return out.join(", ") + ', Infinity...';
      }
    }

    return out.join(", ");
  }
  
};