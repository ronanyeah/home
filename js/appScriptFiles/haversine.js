module.exports = {
  
  haversine: function (values, cartesian) {
    var earth = 6371,
        toRads = function (x) { //convert to Radians
          return x * Math.PI / 180;
        };

    function checkValidity (value) {
      if(isNaN(value) || value < 0) { //if invalid or less than zero
        return 0;
      } else {
        return value;
      }
    }
    
    for(var j = 0; j < 12; j++) { //change inputs to numbers or zero
      values[j] = checkValidity(parseInt(values[j], 10));
    }
    
    for(var i = 0; i < 11; i += 3) { //fix out of range values
      if(values[i] === 180) {
        values[i + 1] = 0;
        values[i + 2] = 0;
      }
      if(values[i] > 180) {
        values[i] = 0;
      }
      if(values[i + 1] > 60) {
        values[i + 1] = 0;
      }
      if(values[i + 2] > 60) {
        values[i + 2] = 0;
      }
    }
    
    var out = [];
    //change to decimal degrees
    out[0] = values[0] + values[1] / 60 + values[2] / 3600;
    out[1] = values[3] + values[4] / 60 + values[5] / 3600;
    out[2] = values[6] + values[7] / 60 + values[8] / 3600;
    out[3] = values[9] + values[10] / 60 + values[11] / 3600;
    
    if(cartesian[0] === 'S') {
      out[0] *= -1;
    }
    if(cartesian[1] === 'W') {
      out[1] *= -1;
    }
    if(cartesian[2] === 'S') {
      out[2] *= -1;
    }
    if(cartesian[3] === 'W') {
      out[3] *= -1;
    }
    
    var longitude1 = out[0],
        latitude1 = out[1],
        longitude2 = out[2],
        latitude2 = out[3];
        
    var rlatitude1 = toRads(longitude1),
        rlatitude2 = toRads(longitude2),
        dlatitude = toRads(longitude2 - longitude1),
        dlongitude = toRads(latitude2 - latitude1),
        a = ( Math.sin(dlatitude / 2) * Math.sin(dlatitude / 2) ) +
          ( Math.cos(rlatitude1) * Math.cos(rlatitude2) * Math.sin(dlongitude / 2) * Math.sin(dlongitude / 2) );

    return Math.floor(earth * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)))) + "km";
  }

};