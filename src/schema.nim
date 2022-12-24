import scripting

from std/os import dirExists, splitPath, createDir
from std/strformat import fmt
from pkg/stb_image/read import load, RGBA
from pkg/stb_image/write import writePNG, RGBA

# Helper functions

proc `+/`(a, b: byte): byte =
  ## Add bytes, a and b, with clamping
  let sum: uint16 = uint16(a) + uint16(b)

  if sum >= 510:
    result = 255
  else:
    result = byte(sum shr 1)

template failure(msg: string): void = return (success: false, message: msg)
template success(msg: string): void = return (success: true, message: msg)

# Actual schema

using args: seq[string]
using state: State

proc psection*(args, state): Result =
  state.rmImports()
  state.rmImages()
  
  if args.len() < 1:
    success("Entered section")
  else:
    success(fmt"Entered section {args[0]}")

proc pset*(args, state): Result =
  if args.len() < 2:
    failure("Not enough parameters for SET <key> <value>")
  
  let value: string = state.interpolate(args[1])

  state.addString(args[0], value)

  success(fmt"Set {args[0]} to {value}")

proc pimport*(args, state): Result =
  if args.len() < 2:
    failure("Not enough parameters for IMPORT <name> <path>")

  try:
    let path: string = state.interpolate(args[1])
  
    state.addImport(args[0], (path: path, file: open(path)))
  
    success(fmt"Imported {args[0]} from {path}")
  
  except IOError:
    failure("Could not open import")
  
proc pclose*(args, state): Result =
  if args.len() < 1:
    failure("Not enough parameters for CLOSE <image>")

  try:
    if not state.hasImport(args[0]):
      failure(fmt"Could find import to close {args[0]}")
    
    state.getImport(args[0]).close()
    state.delImport(args[0])
    
    success(fmt"Closed image {args[0]}")
  
  except IOError:
    failure("Could not close image")

proc popen*(args, state): Result =
  if args.len() < 2:
    failure("Not enough parameters for OPEN <image> <transparent|opaque>")
  
  try:
    if not state.hasImport(args[0]):
      failure(fmt"Could find image to open {args[0]}")
    
    let imprt: Import = state.getImport(args[0])
    
    var w, h, c: int
    let bytes: seq[byte] = load(imprt.path, w, h, c, RGBA)
    
    var tr: bool
    
    case args[1]
    of "transparent": tr = true
    of "opaque": tr = false
    else: tr = false
    
    state.addImage(args[0], (width: w, height: h, channels: c, bytes: bytes, transparent: tr))
    
    success(fmt"Opened image {args[0]}")
  
  except IOError:
    failure("Could not open image")

proc psave*(args, state): Result =
  if args.len() < 2:
    failure("Not enough parameters for SAVE <image> <path>")
  
  try:
    if not state.hasImage(args[0]):
      failure(fmt"Could find image to save {args[0]}")
    
    let image: Image = state.getImage(args[0])
    let path: string = state.interpolate(args[1])
    let dir: string = splitPath(path).head
    
    if not dirExists(dir):
      createDir(dir)
    
    if writePNG(path, image.width, image.height, RGBA, image.bytes):
      success(fmt"Saved image {args[0]} to {path}")
    else:
      failure(fmt"Could not save image {args[0]}")
  
  except IOError:
    failure("Could not save image")

proc pcompose*(args, state): Result =
  if args.len() < 3:
    failure("Not enough parameters for COMPOSE <out> <base> <layer>*")
  
  if not state.hasImage(args[1]):
    failure(fmt"Could find image to compose {args[1]}")
  
  let base: Image = state.getImage(args[1])
  var bytes: seq[byte] = base.bytes

  for name in args[2..high(args)]:
    if not state.hasImage(name):
      continue

    let layer: Image = state.getImage(name)
    var index: int = 0
    
    while index < high(base.bytes):
      let br: byte = bytes[index + 0]
      let bg: byte = bytes[index + 1]
      let bb: byte = bytes[index + 2]
      let ba: byte = bytes[index + 3]
     
      let lr: byte = layer.bytes[index + 0]
      let lg: byte = layer.bytes[index + 1]
      let lb: byte = layer.bytes[index + 2]
      let la: byte = layer.bytes[index + 3]
      
      
      if la == 0:
        index += 4
        continue
      
      if layer.transparent:
        bytes[index + 0] = br +/ lr
        bytes[index + 1] = bg +/ lg
        bytes[index + 2] = bb +/ lb
        bytes[index + 3] = ba +/ la
      else:
        bytes[index + 0] = lr
        bytes[index + 1] = lg
        bytes[index + 2] = lb
        bytes[index + 3] = la

      index += 4

  state.addImage(args[0], (width: base.width, height: base.height, channels: base.channels, bytes: bytes, transparent: false))

  success(fmt"Composed {args[0]}")
