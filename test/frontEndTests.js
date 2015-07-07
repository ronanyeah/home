var Code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();

// var frontEnd = require('../js/frontEnd.js');

lab.test('front end tests', function (done) {
  Code.expect(1).to.equal(1);

  done();
});