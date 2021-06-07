#!/bin/bash
set -ex

docker run \
  -v $(pwd)/data:/data \
  -p 127.0.0.1:8002:8002 \
  valhalla \
  valhalla_service /data/valhalla.json 1
