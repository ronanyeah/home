function haversine() {
    var earth = 6371;
    
    var values = [document.getElementById("hav1.1").value, document.getElementById("hav1.2").value, document.getElementById("hav1.3").value,
                  document.getElementById("hav2.1").value, document.getElementById("hav2.2").value, document.getElementById("hav2.3").value,
                  document.getElementById("hav3.1").value, document.getElementById("hav3.2").value, document.getElementById("hav3.3").value,
                  document.getElementById("hav4.1").value, document.getElementById("hav4.2").value, document.getElementById("hav4.3").value];
    
    for(var i = 0; i < 12; i++) { //change inputs to numbers or zero
        values[i] = parseInt(values[i], 10);
        if(isNaN(values[i]) || values[i] < 0) { //if invalid or less than zero
            values[i] = 0;
        }
    }
    
    for(var i = 0; i < 11; i += 3) { //fix out of range values
        if(values[i] === 180) {values[i+1] = 0; values[i+2] = 0;}
        if(values[i] > 180) {values[i] = 0;}
        if(values[i+1] > 60) {values[i+1] = 0;}
        if(values[i+2] > 60) {values[i+2] = 0;}
    }
    
    var cart = [document.getElementById("havC1").value, document.getElementById("havC2").value,
                document.getElementById("havC3").value, document.getElementById("havC4").value];
    
    var t = [];
    var e = values;
    //change to decimal degrees
    t[0] = e[0] + e[1] / 60 + e[2] / 3600;
    t[1] = e[3] + e[4] / 60 + e[5] / 3600;
    t[2] = e[6] + e[7] / 60 + e[8] / 3600;
    t[3] = e[9] + e[10] / 60 + e[11] / 3600;
    
    if(cart[0] === 'S') {t[0] *= -1};
    if(cart[1] === 'W') {t[1] *= -1};
    if(cart[2] === 'S') {t[2] *= -1};
    if(cart[3] === 'W') {t[3] *= -1};
    
    var a = t[0], //lon1
        o = t[1], //lat1
        i = t[2], //lon2
        u = t[3]; //lat2
    
    function toRads(x) { //convert to Radians
    return x * Math.PI / 180
    }
        
    rLat1 = toRads(a), rLat2 = toRads(i), dLat = toRads(i - a), dLon = toRads(u - o);
    var r = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(rLat1) * Math.cos(rLat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2),
        d = 2 * Math.atan2(Math.sqrt(r), Math.sqrt(1 - r));
    return isNaN(d) ? "ERROR" : Math.floor(earth * d) + "km";
}

function vigEncode() {
    for (var e = document.getElementById("vigMesEnc").value, t = document.getElementById(
                "vigPasEnc").value, n = "abcdefghijklmnopqrstuvwxyz", a =
            "", o = 0; o < e.length; o++)
        if (-1 !== n.indexOf(e[o])) {
            var i = t[o % t.length],
                u = n.indexOf(i),
                r = n.indexOf(e[o]);
            a += n[(u + r) % n.length]
        }
        else a += e[o];
    return a
}

function vigDecode() {
    for (var e = document.getElementById("vigMesDec").value, t = document.getElementById(
                "vigPasDec").value, n = "abcdefghijklmnopqrstuvwxyz", a =
            "", o = 0; o < e.length; o++)
        if (-1 !== n.indexOf(e[o])) {
            var i = t[o % t.length],
                u = n.indexOf(i),
                r = n.indexOf(e[o]);
            a += n[(r - u + n.length) % n.length]
        }
        else a += e[o];
    return a
}

function fibonacci() {
    var e = document.getElementById("fiboInput").value;
    if (1 > e) return [];
    for (var t = [0, 1], n = [], a = 0; n.length < e; a++) n.push(t[0]), t.push(
        t[0] + t[1]), t = t.slice(1);
    return n.join(", ")
}

function encode() {
    var u;
    var e =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        t = document.getElementById("userInputEnc").value;
    if (0 === t.length) return 'ENTER SOME TEXT!';
    var n, a = [];
    if (/([^\u0000-\u00ff])/.test(t) || void 0 === t) {
        return 'INPUT ASCII CHARACTERS ONLY!';
    }
    for (var o = 0; o < t.length; o++) {
        var i = t.charCodeAt(o);
        u = o % 3;
        switch (u) {
            case 0:
                a.push(e.charAt(i >> 2));
                break;
            case 1:
                a.push(e.charAt((3 & n) << 4 | i >> 4));
                break;
            case 2:
                a.push(e.charAt((15 & n) << 2 | i >> 6)), a.push(e.charAt(
                    63 & i));
        }
        n = i
    }
    return 0 === u ? (a.push(e.charAt((3 & n) << 4)), a.push("==")) : 1 ===
        u && (a.push(e.charAt((15 & n) << 2)), a.push("=")), a.join("")
}

function decode() {
    var e =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        t = document.getElementById("userInputDec").value;
    if (0 === t.length) return 'ENTER SOME TEXT!';
    var n, a = [];
    if (t = t.replace(/\s+/g, ""), !/^[a-z0-9\+\/\s]+\={0,2}$/i.test(t) ||
        t.length % 4 > 0) return 'ENTER A VALID STRING!';
    t = t.replace(/=/g, "");
    for (var o = 0; o < t.length; o++) {
        var i = e.indexOf(t.charAt(o)),
            u = o % 4;
        switch (u) {
            case 0:
                break;
            case 1:
                a.push(String.fromCharCode(n << 2 | i >> 4));
                break;
            case 2:
                a.push(String.fromCharCode((15 & n) << 4 | i >> 2));
                break;
            case 3:
                a.push(String.fromCharCode((3 & n) << 6 | i));
        }
        n = i;
    }
    return a.join("");
}

$(document).ready(function () {
    //hide result and input divs
    $("#sixfour").hide();
    $("#resultBase").hide();
    $("#fibo").hide();
    $("#resultFib").hide();
    $("#vig").hide();
    $("#resultVig").hide();
    $("#hav").hide();
    $("#resultHav").hide();
    
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
    $(".hatch").hover(function() {
            $(this).addClass("plink"),
            $(this).stop().animate({paddingBottom: "+=10px"}, 'fast');
        },
        function() {
            $(this).removeClass("plink"),
            $(this).stop().animate({paddingBottom: "-=10px"}, 'fast');
        }
    );
    
    //input divs
    $("#sixfourHatch").click(function() {
        $("#sixfour").fadeToggle("slow");
    });
    $("#fibHatch").click(function() {
        $("#fibo").fadeToggle("slow");
    });
    $("#vigHatch").click(function() {
        $("#vig").fadeToggle("slow");
    });
    $("#havHatch").click(function() {
        $("#hav").fadeToggle("slow");
    });
    
    //result divs
    $("#button1").click(function() {
        $("#resultBase").fadeIn("slow"),
        $("#outBase").hide().html("<strong>" + encode() + "</strong>").fadeIn("slow");
    });
    
    $("#button2").click(function() {
        $("#resultBase").fadeIn("slow"),
        $("#outBase").hide().html("<strong>" + decode() + "</strong>").fadeIn("slow");
    });
    
    $("#buttonFib").click(function() {
        $("#resultFib").fadeIn("slow"),
        $("#outFib").hide().html("<strong>" + fibonacci() + "</strong>").fadeIn("slow");
    });
    
    $("#buttonVigEnc").click(function() {
        $("#resultVig").fadeIn("slow"),
        $("#outVig1").html("Your encoded super-secret string is:"),
        $("#outVig2").hide().html("<strong>" + vigEncode() + "</strong>").fadeIn("slow");
    });
    
    $("#buttonVigDec").click(function() {
        $("#resultVig").fadeIn("slow"),
        $("#outVig1").html("Your decoded message is:"),
        $("#outVig2").hide().html("<strong>" + vigDecode() + "</strong>").fadeIn("slow");
    });
    
    $("#buttonHav").click(function() {
        $("#resultHav").fadeIn("slow"),
        $("#outHav1").html("Your points are apart by:"),
        $("#outHav2").hide().html("<strong>" + haversine() + "</strong>").fadeIn("slow");
    });
    
});