var code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();

var scripts = require('../js/script.js');

lab.test('base64 encode', function (done) {
  code.expect(scripts.base64Encode('')).to.equal('ENTER SOME TEXT!');

  code.expect(scripts.base64Encode('™')).to.equal('ASCII CHARACTERS ONLY!');

  //padding test 'none'
  code.expect(scripts.base64Encode('go1')).to.equal('Z28x');

  //padding test '='
  code.expect(scripts.base64Encode('go')).to.equal('Z28=');

  //padding test '=='
  code.expect(scripts.base64Encode('go22')).to.equal('Z28yMg==');

  done();
});

lab.test('base64 decode', function (done) {
  code.expect(scripts.base64Decode('')).to.equal('ENTER SOME TEXT!');

  code.expect(scripts.base64Decode('aaaaa')).to.equal('ENTER A VALID STRING!');

  code.expect(scripts.base64Decode('#')).to.equal('ENTER A VALID STRING!');

  code.expect(scripts.base64Decode('Z28yMg==')).to.equal('go22');

  done();
});

lab.test('fibonacci', function (done) {
  code.expect(scripts.fibonacci(-1)).to.equal("Invalid input!");

  code.expect(scripts.fibonacci("x")).to.equal("Invalid input!");

  code.expect(scripts.fibonacci(5)).to.equal("0, 1, 1, 2, 3");
  done();
});

lab.test('vigenere encode', function (done) {
  code.expect(scripts.vigEncode("testing", "test")).to.equal("mikmbry");

  code.expect(scripts.vigEncode("te$ting", "test")).to.equal("mi$mbry");
  done();
});

lab.test('vigenere decode', function (done) {
  code.expect(scripts.vigDecode("mikmbry", "test")).to.equal("testing");

  code.expect(scripts.vigDecode("mi$mbry", "test")).to.equal("te$ting");
  done();
});

lab.test('haversine', function (done) {
  code.expect(scripts.haversine(["x",-1,0,0,0,0,1,1,1,1,1,1], ['N', 'E', 'N', 'E'])).to.equal("159km");

  code.expect(scripts.haversine([180,1,1,181,61,61,1,1,1,1,1,1], ['S', 'W', 'S', 'W'])).to.equal("19855km");

  done();
});