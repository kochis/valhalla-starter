#!/bin/bash

set -ex

mkdir -p ./data/osm_data/

wget 'https://download.geofabrik.de/north-america/us/new-york-latest.osm.pbf' -O ./data/osm_data/new-york-latest.osm.pbf

echo "Done."
