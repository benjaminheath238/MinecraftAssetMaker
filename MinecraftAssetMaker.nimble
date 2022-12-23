# Package
version       = "1.1.0"
author        = "Benjamin Heath"
description   = "A tool to create textures and other assets for minecraft"
license       = "MIT"
srcDir        = "src"
bin           = @["MinecraftAssetMaker"]
backend       = "c"

# Dependencies
requires "nim >= 1.6.8"
requires "stb_image >= 2.5"
