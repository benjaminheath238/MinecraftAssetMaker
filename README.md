# Minecraft Asset Maker

Minecraft asset maker is a tool to create the large number of json files and textures that are used in minecraft mod development.

## Features

* [x] Create textures
* [ ] Create block states
* [ ] Create block/blockitem models
* [ ] Create item models
* [ ] Create locales

## Setup

1. Dowload binary from latest [here](https://github.com/benjaminheath238/MinecraftAssetMaker/releases/latest)
2. Create file `config.mcam`
3. Setup script
4. Execute binary

## How to use

Variables can be set using `SET <name> <value>` this is useful to reduce repetition caused errors. The value of a variable can be accessed by using `${name}`.

### Texture creation

1. Import the files using `IMPORT <name> <path>`
2. Open the textures using `OPEN <name> <transparent|opaque>`
3. Create the file texture using `COMPOSE <name> <layers>`, where `<layers>` represent the names of textures opened in step 2
4. Save the created texture using `SAVE <name> <path>`
