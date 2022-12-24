import scripting

from schema import nil

from std/tables import newTable
from std/os import getCurrentDir

when isMainModule:
  let engine: ScriptEngine = newScriptEngine()
  
  engine["SECTION"] = schema.psection
  engine["SET"] = schema.pset
  engine["IMPORT"] = schema.pimport
  engine["CLOSE"] = schema.pclose
  engine["OPEN"] = schema.popen
  engine["SAVE"] = schema.psave
  engine["COMPOSE"] = schema.pcompose
  
  engine.uses(newState(newTable({"home": getCurrentDir()})))
  engine.load(newProgram(open("config.mcam")))
  engine.execute()
