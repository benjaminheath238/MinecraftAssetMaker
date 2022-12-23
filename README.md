[![Release](https://github.com/benjaminheath238/MinecraftAssetMaker/actions/workflows/release.yaml/badge.svg)](https://github.com/benjaminheath238/MinecraftAssetMaker/actions/workflows/release.yaml)

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

The variable `home` represents the directory the binary was executed from.

Sections can be created to separate loaded textures and imports by using `SECTION <name>` 

### Texture creation

1. Import the files using `IMPORT <name> <path>`
2. Open the textures using `OPEN <name> <transparent|opaque>`
3. Create the file texture using `COMPOSE <name> <layers>`, where `<layers>` represent the names of textures opened in step 2
4. Save the created texture using `SAVE <name> <path>`

### Example

```
SET modid example_mod

SET i_dir ${home}/assets/i
SET o_dir ${home}/assets/o

SECTION blocks

IMPORT lb_plate ${i_dir}/lb_plate.png
IMPORT lb_noise_dark ${i_dir}/lb_noise_dark.png
IMPORT lb_noise_light ${i_dir}/lb_noise_light.png
IMPORT bb_steel ${i_dir}/bb_steel.png

OPEN lb_plate transparent
OPEN lb_noise_dark transparent
OPEN lb_noise_light transparent
OPEN bb_steel opaque

COMPOSE b_steel_plate_light bb_steel lb_noise_light lb_plate
COMPOSE b_steel_plate_dark bb_steel lb_noise_dark lb_plate

SAVE b_steel_plate_light ${o_dir}/b_steel_plate_light.png
SAVE b_steel_plate_dark ${o_dir}/b_steel_plate_dark.png
```

In the above example the following happens;

1. The variable `modid` is set to `example_mod`
2. The directories for reading and writing files are set
3. A section called `blocks` is made
4. The files `lb_plate`, `lb_noise_dark`, `lb_noise_light` and `bb_steel` are imported
5. The files are loaded as textures
6. The two textures `b_steel_plate_light` and `b_steel_plate_dark` are composed
7. The texture from set 6 are saved

