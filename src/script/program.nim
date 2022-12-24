from std/strutils import strip, split, isEmptyOrWhitespace, replace
from std/sequtils import filter, map
from std/sugar import `=>`, `->`

type Command* = tuple[name: string, args: seq[string], line: int]
type Program* = ref object
  commands*: seq[Command]

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
      .map(x => x.strip())
      .filter(x => not x.isEmptyOrWhitespace() or x[0] != '#')

  return (name: words[0], args: words[1..words.len() - 1], line: line.number)

proc compile*(this: Program, file: File): void =
  for line in file.lines():
    this.commands.add(line.parse())

proc newProgram*(): Program =
  result = Program()
  result.commands = newSeq[Command]()

proc newProgram*(file: File): Program =
  result = newProgram()
  result.compile(file)