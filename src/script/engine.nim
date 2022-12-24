from std/sugar import `=>`, `->`
from std/tables import TableRef, newTable, `[]`, `[]=`, contains, pairs, `$`, del
from std/terminal import styledWriteLine, fgRed, fgGreen, resetAttributes
from std/strformat import fmt
from program import Program
from state import State

type Result* = tuple[success: bool, message: string]
type Function* = (args: seq[string], state: State) -> Result 
type ScriptEngine* = ref object
  functions: TableRef[string, Function]
  program: Program
  state: State

proc `[]=`*(this: ScriptEngine, name: string, function: Function): void =
  this.functions[name] = function

template register*(this: ScriptEngine, name: string, code: untyped): void =
  this.functions[name] = (args, state) => code

proc load*(this: ScriptEngine, program: Program): void = this.program = program
proc uses*(this: ScriptEngine, state: State): void = this.state = state

proc execute*(this: ScriptEngine): void =
  for command in this.program.commands:
    if this.functions.contains(command.name):
      let result = this.functions[command.name](command.args, this.state)

      if result.success:
        stdout.styledWriteLine(fgGreen, fmt"[SUCCESS]-[LINE={command.line}]: {result.message}")
      else:
        stdout.styledWriteLine(fgRed, fmt"[FAILURE]-[LINE={command.line}]: {result.message}")

  stdout.resetAttributes()

proc newScriptEngine*(): ScriptEngine =
  result = ScriptEngine()
  result.functions = newTable[string, Function]()
