var assert = require('assert');
var script = require('../js/script.js');

assert.equal(script.haversine([1,1,1,1,1,1,1,1,1,1,1,1], ['N', 'E', 'S', 'W']), "319km", "haversine");

// var Code = require('code');   // assertion library
// var Lab = require('lab');
// var lab = exports.lab = Lab.script();

// lab.test('returns true when 1 + 1 equals 2', function (done) {

//     Code.expect(1+1).to.equal(2);
//     done();
// });