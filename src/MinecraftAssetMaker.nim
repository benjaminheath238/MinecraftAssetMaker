import scripting

from scheme import nil
from std/tables import newTable
from std/os import getCurrentDir

when isMainModule:
  let engine: ScriptEngine = newScriptEngine()
  
  engine["SECTION"] = scheme.fsection
  engine["SET"] = scheme.fset
  engine["IMPORT"] = scheme.fimport
  engine["CLOSE"] = scheme.fclose
  engine["OPEN"] = scheme.fopen
  engine["SAVE"] = scheme.fsave
  engine["COMPOSE"] = scheme.fcompose
  
  engine.uses(newState(newTable({"home": getCurrentDir()})))
  engine.load(newProgram(open("config.mcam")))
  engine.execute()
