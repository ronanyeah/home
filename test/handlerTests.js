var code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();

var handlers = require('../js/handlers.js');

lab.test('x', function (done) {

  code.expect(1).to.equal(1);

  done();
});