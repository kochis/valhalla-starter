# Valhalla Starter

This repo is used for starting up a local Valhalla instance with some OSM data.

## Download Data
By default, this repo uses the [New York](https://download.geofabrik.de/north-america/us/new-york.html) extract from Geofabrik. 

You can use any OSM data, provided you update the `OSM_FILE` var in `script.sh` accordingly. Keep in mind the build will take a long time on larger datasets.

Run `./download_data.sh` to download the New York extract into the `data/` folder.

## Setup
To build Valhalla, as well as the routing data, run the `./setup.sh` command after downloading the OSM data. The script will do the following:
* Build the Valhalla docker image
* Generate the `valhalla.json` config file
* Build administrative data (based on the OSM data)
* Build timezone data
* Build Valhalla tiles (routing indexes)
* Combine all tiles into a `.tar` file

## Start Valhalla
To start Valhalla, after running the setup script, you can run `./start.sh` which should start the server at `http://localhost:8002`
