$(document).ready(function () {
  //hide result and input divs
  $('#sixfour').hide();
  $('#resultBase').hide();
  $('#fibo').hide();
  $('#resultFib').hide();
  $('#vig').hide();
  $('#resultVig').hide();
  $('#hav').hide();
  $('#resultHav').hide();
  
  //enter key support
  $('#userInputEnc').keypress(function(e){
    if(e.keyCode === 13) $('#button1').click();
  });
  
  $('#userInputDec').keypress(function(e){
    if(e.keyCode === 13) $('#button2').click();
  });
  
  $('#fiboInput').keypress(function(e){
    if(e.keyCode === 13) $('#buttonFib').click();
  });
  
  $('#vigMesEnc, #vigPasEnc').keypress(function(e){
    if(e.keyCode === 13) $('#buttonVigEnc').click();
  });
  
  $('#vigMesDec, #vigPasDec').keypress(function(e){
    if(e.keyCode === 13) $('#buttonVigDec').click();
  });
  
  $('.inputHav').keypress(function(e){
    if(e.keyCode === 13) $('#buttonHav').click();
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
  $('#sixfourHatch').click(function() {
    $('#sixfour').fadeToggle('slow');
  });
  $('#fibHatch').click(function() {
    $('#fibo').fadeToggle('slow');
  });
  $('#vigHatch').click(function() {
    $('#vig').fadeToggle('slow');
  });
  $('#havHatch').click(function() {
    $('#hav').fadeToggle('slow');
  });
  
  //result divs
  $('#button1').click(function() {
    $('#resultBase').fadeIn('slow');
    $('#outBase').hide().html('<strong>' + funcs.base64Encode() + '</strong>').fadeIn('slow');
  });
  
  $('#button2').click(function() {
    $('#resultBase').fadeIn('slow');
    $('#outBase').hide().html('<strong>' + funcs.base64Decode() + '</strong>').fadeIn('slow');
  });
  
  $('#buttonFib').click(function() {
    $('#resultFib').fadeIn('slow');
    $('#outFib').hide().html('<strong>' + funcs.fibonacci() + '</strong>').fadeIn('slow');
  });
  
  $('#buttonVigEnc').click(function() {
    $('#resultVig').fadeIn('slow');
    $('#outVig1').html('Your encoded super-secret string is:');
    $('#outVig2').hide().html('<strong>' + funcs.vigEncode() + '</strong>').fadeIn('slow');
  });
  
  $('#buttonVigDec').click(function() {
    $('#resultVig').fadeIn('slow');
    $('#outVig1').html('Your decoded message is:');
    $('#outVig2').hide().html('<strong>' + funcs.vigDecode() + '</strong>').fadeIn('slow');
  });
  
  $('#buttonHav').click(function() {
    $('#resultHav').fadeIn('slow');
    $('#outHav1').html('Your points are apart by:');
    $('#outHav2').hide().html('<strong>' + funcs.haversine() + '</strong>').fadeIn('slow');
  });
  
});