var Code = require('code'),
    Lab = require('lab'),
    lab = exports.lab = Lab.script();

var base64 = require('../javascript/public/apps/base64.js'),
    fibonacci = require('../javascript/public/apps/fibonacci.js'),
    vigenere = require('../javascript/public/apps/vigenere.js');

lab.test('base64 encode tests', function (done) {
  Code.expect(base64.encode('')).to.equal('ENTER SOME TEXT!');

  Code.expect(base64.encode('™')).to.equal('ASCII CHARACTERS ONLY!');

  //padding test 'none'
  Code.expect(base64.encode('go1')).to.equal('Z28x');

  //padding test '='
  Code.expect(base64.encode('go')).to.equal('Z28=');

  //padding test '=='
  Code.expect(base64.encode('go22')).to.equal('Z28yMg==');

  done();
});

lab.test('base64 decode tests', function (done) {
  Code.expect(base64.decode('')).to.equal('ENTER SOME TEXT!');

  Code.expect(base64.decode('aaaaa')).to.equal('ENTER A VALID STRING!');

  Code.expect(base64.decode('#')).to.equal('ENTER A VALID STRING!');

  Code.expect(base64.decode('Z28yMg==')).to.equal('go22');

  done();
});

lab.test('fibonacci tests', function (done) {
  Code.expect(fibonacci.fibonacci(-1)).to.equal("Invalid input!");

  Code.expect(fibonacci.fibonacci("x")).to.equal("Invalid input!");

  Code.expect(fibonacci.fibonacci(5)).to.equal("0, 1, 1, 2, 3");
  done();
});

lab.test('vigenere encode tests', function (done) {
  Code.expect(vigenere.encode("testing", "test")).to.equal("mikmbry");

  Code.expect(vigenere.encode("te$ting", "test")).to.equal("mi$mbry");
  done();
});

lab.test('vigenere decode tests', function (done) {
  Code.expect(vigenere.decode("mikmbry", "test")).to.equal("testing");

  Code.expect(vigenere.decode("mi$mbry", "test")).to.equal("te$ting");
  done();
});