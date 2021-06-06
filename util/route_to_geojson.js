#!/usr/bin/env node

const decode = require('./decode');

async function readStdinSync() {
  return new Promise(resolve => {
    let data = ''
    process.stdin.setEncoding('utf8')
    process.stdin.resume()
    const t = setTimeout(() => {
      process.stdin.pause()
      resolve(data)
    }, 1e3)
    process.stdin.on('readable', () => {
      let chunk
      while ((chunk = process.stdin.read())) {
        data += chunk
      }
    }).on('end', () => {
      clearTimeout(t)
      resolve(data)
    })
  })
}

const run = async () => {
  const input = await readStdinSync();
  const response = JSON.parse(input);

  const features = [];
  response.trip.legs.forEach((leg, index) => {
    const route = decode(leg.shape);

    (leg.maneuvers || []).forEach((maneuver) => {
      maneuver.leg = index;
      const { begin_shape_index, end_shape_index } = maneuver;

      const coordinates = route.slice(begin_shape_index, end_shape_index + 1);
      const geometry = {
        type: coordinates.length > 1 ? 'LineString' : 'Point',
        coordinates: coordinates.length > 1 ? coordinates : coordinates[0],
      }

      features.push({
        type: 'Feature',
        properties: maneuver,
        geometry,
      });
    });
  });

  const collection = {
    type: 'FeatureCollection',
    features,
  };

  console.log(JSON.stringify(collection, null, 2));
};

run();
