#!/bin/bash
set -ex

OSM_FILE='new-york-latest.osm.pbf'

if [[ ! -f "./data/osm_data/$OSM_FILE" ]] ; then
  echo 'No OSM data is present in data/osm_data/, aborting.'
  exit 1
fi

# build image
# the -t tags the image as "valhalla"
docker build -t valhalla .
sleep 5

# genearte valhalla.json
docker run -t valhalla ./valhalla/scripts/valhalla_build_config > ./data/valhalla.json
sleep 5

# first, build admin data
# will create file data/valhalla/admin.sqlite
docker run \
  -v $(pwd)/data:/data \
  valhalla \
  valhalla_build_admins --config /data/valhalla.json /data/osm_data/$OSM_FILE
sleep 5


# next build timezone data
docker run \
  -v $(pwd)/data:/data \
  valhalla \
  ./valhalla/scripts/valhalla_build_timezones > data/valhalla/tz_world.sqlite
sleep 5


# build tiles
docker run \
  -v $(pwd)/data:/data \
  valhalla \
  valhalla_build_tiles --config /data/valhalla.json /data/osm_data/$OSM_FILE
sleep 5

# tar up tiles
find data/valhalla/tiles/* | sort -n | tar -cf data/valhalla/tiles.tar --no-recursion -T -
