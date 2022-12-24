from std/strutils import strip, split, isEmptyOrWhitespace, replace
from std/sequtils import filter, map
from std/sugar import `=>`, `->`

type Command* = tuple[name: string, args: seq[string], line: int]
type Program* = ref object
  commands: seq[Command]
  command: int

iterator lines(file: File): tuple[text: string, number: int] =
  var line: int
  var text: string

  while true:
    try:
      text = file.readLine()
      line.inc()
      
      if text.isEmptyOrWhitespace() or text[0] == '#':
        continue

      yield (text: text, number: line)
    except IOError:
      break

proc parse(line: tuple[text: string, number: int]): Command =
  let words: seq[string] = line.text
      .strip()
      .split(" ")
      .filter(x => not x.isEmptyOrWhitespace())

  return (name: words[0], args: words[1..words.len() - 1], line: line.number)

proc compile*(this: Program, file: File): void =
  for line in file.lines():
    this.commands.add(line.parse())

proc command*(this: Program): int = this.command
proc len*(this: Program): int = this.commands.len()
proc next*(this: Program): void = this.command += 1
proc goto*(this: Program, command: int): void = this.command = command
proc call*(this: Program): Command = this.commands[this.command]
proc finished*(this: Program): bool = this.command >= this.len()

proc newProgram*(): Program =
  result = Program()
  result.commands = newSeq[Command]()

proc newProgram*(file: File): Program =
  result = newProgram()
  result.compile(file)