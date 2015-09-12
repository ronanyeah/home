'use strict';

var base64 = require('./apps/base64.js'),
    fibonacci = require('./apps/fibonacci.js'),
    vigenere = require('./apps/vigenere.js'),
    haversine = require('./apps/haversine.js'),
    cookieScripts = require('./cookieScripts.js'),
    $ = require('jquery');

function hideDropdownDivs() {
  $('#base64Drop').hide();
  $('#base64Result').hide();
  $('#fibonacciDrop').hide();
  $('#fibonacciResult').hide();
  $('#vigenereDrop').hide();
  $('#vigenereResult').hide();
  $('#haversineDrop').hide();
  $('#haversineResult').hide();
}

window.onload = function() {
  hideDropdownDivs();
  cookieScripts.cookieCheck();

};

$('#jumbotron div:first-child').click(function() {
  window.location = "/analytics";
});

//enter key support
$('#userInputEnc').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#button1').click();
  }
});

$('#userInputDec').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#button2').click();
  }
});

$('#fiboInput').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#buttonFib').click();
  }
});

$('#vigMesEnc, #vigPasEnc').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#buttonVigEnc').click();
  }
});

$('#vigMesDec, #vigPasDec').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#buttonVigDec').click();
  }
});

$('.inputHav').keypress(function(e) {
  if (e.keyCode === 13) {
    $('#buttonHav').click();
  }
});

//hatch color change
$('.hatch').hover(function() {
  $(this).addClass('plink');
  $(this).stop().animate({paddingBottom: '+=10px'}, 'fast');
}, function() {
  $(this).removeClass('plink');
  $(this).stop().animate({paddingBottom: '-=10px'}, 'fast');
});

//input divs
$('#base64Hatch').click(function() {
  $('#base64Drop').fadeToggle('slow');
});
$('#fibonacciHatch').click(function() {
  $('#fibonacciDrop').fadeToggle('slow');
});
$('#vigenereHatch').click(function() {
  $('#vigenereDrop').fadeToggle('slow');
});
$('#haversineHatch').click(function() {
  $('#haversineDrop').fadeToggle('slow', function() {
    haversine.makeMap();
  });
});

//result divs
$('#button1').click(function() {
  $('#base64Result').fadeIn('slow');
  $('#outBase').hide().html('<strong>' + base64.encode(document.getElementById('userInputEnc').value) + '</strong>').fadeIn('slow');
});

$('#button2').click(function() {
  $('#base64Result').fadeIn('slow');
  $('#outBase').hide().html('<strong>' + base64.decode(document.getElementById('userInputDec').value) + '</strong>').fadeIn('slow');
});

$('#buttonFib').click(function() {
  $('#fibonacciResult').fadeIn('slow');
  $('#outFib').hide().html('<strong>' + fibonacci.fibonacci(document.getElementById('fiboInput').value) + '</strong>').fadeIn('slow');
});

$('#buttonVigEnc').click(function() {
  $('#vigenereResult').fadeIn('slow');
  $('#outVig1').html('Your encoded super-secret string is:');
  $('#outVig2').hide().html('<strong>' +
    vigenere.encode(
      document.getElementById('vigMesEnc').value,
      document.getElementById('vigPasEnc').value
    ) + '</strong>').fadeIn('slow');
});

$('#buttonVigDec').click(function() {
  $('#vigenereResult').fadeIn('slow');
  $('#outVig1').html('Your decoded message is:');
  $('#outVig2').hide().html('<strong>' +
    vigenere.decode(
      document.getElementById('vigMesDec').value,
      document.getElementById('vigPasDec').value
    ) + '</strong>').fadeIn('slow');
});