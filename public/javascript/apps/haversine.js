'use strict';

var leaflet = require('leaflet'),
    $ = require('jquery'),
    coordinateArray = [{lat: 51.505, lng: -0.09}], //merry old London
    currentPosition,
    clickMarker,
    mapLine,
    map;

leaflet.Icon.Default.imagePath = '/static/images/leafletImages';

var haversineFunctions = {

  makeMap: function() {
    if (map) {
      map.remove();
      $('#haversineResult').hide();
    }
    
    map = leaflet.map('leaflet').fitWorld();
    
    leaflet.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      id: "wallcrawler.90e45220",
      accessToken: "pk.eyJ1Ijoid2FsbGNyYXdsZXIiLCJhIjoiZjU1OTRlMjJjNDQ3ZTU4MzdlM2U3NTQwMmJkYjM0MjkifQ.PZGNCUHmnpf8_d8GQOuYdA"
    }).addTo(map);

    haversineFunctions.getCurrentPosition();

    map.on('click', haversineFunctions.onMapClick);
  },

  getCurrentPosition: function() {
    navigator.geolocation.getCurrentPosition(function(position) {
      currentPosition = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      coordinateArray.push(currentPosition);
      map.setView(currentPosition, 13);

      leaflet.popup()
        .setLatLng(currentPosition)
        .setContent("You are here!")
        .openOn(map);

      $.ajax({
        type: "POST",
        url: '/sendLocation',
        data: {coordinate: JSON.stringify(currentPosition)}
      });
    });
  },

  onMapClick: function(clickPoint) {
    haversineFunctions.updateCoordinateArray(clickPoint.latlng);
    haversineFunctions.addMarker(clickPoint.latlng);
    haversineFunctions.addLine();

    // zoom the map to the mapLine
    // map.fitBounds(polyline.getBounds());

    $('#haversineResult').fadeIn('slow');
    $('#outHav1').html('Your points are apart by:');
    $('#outHav2').hide().html('<strong>' + haversineFunctions.haversineFormula(coordinateArray) + '</strong>').fadeIn('slow');
  },

  updateCoordinateArray: function(coordinate) {
    coordinateArray.push({
      lat: coordinate.lat,
      lng: coordinate.lng
    });

    if (coordinateArray.length > 2) {
      coordinateArray = coordinateArray.slice(1);
    }
  },

  addMarker: function(coordinate) {
    if (clickMarker) {
      map.removeLayer(clickMarker);
    }

    clickMarker = leaflet.marker(coordinate);
    map.addLayer(clickMarker);
  },

  addLine: function() {
    if (mapLine) {
      map.removeLayer(mapLine);
    }

    mapLine = leaflet.polyline(coordinateArray, {color: 'red'});
    map.addLayer(mapLine);
  },

  haversineFormula: function(cooordinateArray) {
    var earth = 6371,
        output;

    function toRads (cooordinate) { //convert to Radians
      return cooordinate * Math.PI / 180;
    }
    
    var latitude1 = cooordinateArray[0].lat,
        longitude1 = cooordinateArray[0].lng,
        latitude2 = cooordinateArray[1].lat,
        longitude2 = cooordinateArray[1].lng;
        
    var rlatitude1 = toRads(longitude1),
        rlatitude2 = toRads(longitude2),
        dlatitude = toRads(longitude2 - longitude1),
        dlongitude = toRads(latitude2 - latitude1),
        a = ( Math.sin(dlatitude / 2) * Math.sin(dlatitude / 2) ) +
          ( Math.cos(rlatitude1) * Math.cos(rlatitude2) * Math.sin(dlongitude / 2) * Math.sin(dlongitude / 2) );

    output = earth * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)));
    return Math.round(output * 100) / 100 + "km";
  }

};

module.exports = haversineFunctions;