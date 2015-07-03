var code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();

var routes = require('../js/routes.js');

lab.test('x', function (done) {

  code.expect(1).to.equal(1);

  done();
});