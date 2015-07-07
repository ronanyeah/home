var Code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();
// var lab = exports.lab = require("lab").script();
var server = require('../server.js');

lab.test('server test', function (done) {
  server.inject({method: 'GET', url: '/'}, function (res) {
    Code.expect(res.statusCode).to.equal(200);
    
    done();
  });
});