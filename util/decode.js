#!/usr/bin/env node

const decode = function(encoded, precision = 6) {
  encoded = encoded.replace(/\\\\/g, '\\'); // unescape

  let len = encoded.length;
  let index = 0;
  let lat = 0;
  let lng = 0;
  let coordinates = [];

  precision = Math.pow(10, -precision);

  while (index < len) {
    let b;
    let shift = 0;
    let result = 0;

    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    let dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lat += dlat;
    shift = 0;
    result = 0;

    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    let dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    // coordinate order for geojson: [lng, lat]
    coordinates.push([lng * precision, lat * precision]);
  }

  return coordinates;
};

if (process.argv[2]) {
  const coordinates = decode(process.argv[2], 6);
  console.log(JSON.stringify({ type: 'LineString', coordinates }));
}

module.exports = decode;
