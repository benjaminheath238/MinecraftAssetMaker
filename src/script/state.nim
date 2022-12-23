from std/strutils import strip, split, isEmptyOrWhitespace, replace
from std/tables import TableRef, newTable, `[]`, `[]=`, contains, pairs, `$`, del, clear
from std/strformat import fmt

type Import* = tuple[path: string, file: File]
type Image* = tuple[width: int, height: int, channels: int, bytes: seq[byte], transparent: bool]
type State* = ref object
  strings: TableRef[string, string]
  imports: TableRef[string, Import]
  images: TableRef[string, Image]

proc interpolate*(this: State, text: string): string =
  result = text
  for (k, v) in this.strings.pairs():
    result = result.replace("${" & k & "}", v)

proc addString*(this: State, key: string, value: string): void = this.strings[key] = value
proc getString*(this: State, key: string): string = this.strings[key]
proc delString*(this: State, key: string): void = this.strings.del(key)
proc rmStrings*(this: State): void = this.strings.clear()

proc addImport*(this: State, key: string, value: Import): void = this.imports[key] = value
proc getImport*(this: State, key: string): Import = this.imports[key]
proc delImport*(this: State, key: string): void = this.imports.del(key)
proc rmImports*(this: State): void = this.imports.clear()

proc addImage*(this: State, key: string, value: Image): void = this.images[key] = value
proc getImage*(this: State, key: string): Image = this.images[key]
proc delImage*(this: State, key: string): void = this.images.del(key)
proc rmImages*(this: State): void = this.images.clear()

proc `$`*(this: State): string =
  result = fmt"(strings: {this.strings}, imports: {this.imports}, images: {this.images})"

proc newState*(strings: TableRef[string, string] = newTable[string, string]()): State =
  result = State()
  result.strings = strings
  result.imports = newTable[string, Import]()
  result.images = newTable[string, Image]()
