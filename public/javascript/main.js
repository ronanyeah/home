'use strict';

var base64        = require('./apps/base64.js'),
    fibonacci     = require('./apps/fibonacci.js'),
    vigenere      = require('./apps/vigenere.js'),
    haversine     = require('./apps/haversine.js'),
    cookieScripts = require('./cookieScripts.js'),
    $             = require('jquery');

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
  window.location = '/analytics';
});

// Enter button support
$('input').keypress(function(e) {
  if (e.keyCode === 13) {
    $(this).next('.button').click();
  }
});

$('form').keypress(function(e) {
  if (e.keyCode === 13) {
    $(this).next('.button').click();
  }
});

//hatch color change
$('.hatch').hover(
  function() {
    $(this).addClass('plink');
    $(this).stop().animate({paddingBottom: '+=10px'}, 'fast');
  },
  function() {
    $(this).removeClass('plink');
    $(this).stop().animate({paddingBottom: '-=10px'}, 'fast');
  }
);

//input divs
$('.hatch').click(function() {
  $(this).next('.drop').fadeToggle('slow');
});

$('#haversineHatch').bind('click', function() {
  haversine.makeMap();
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