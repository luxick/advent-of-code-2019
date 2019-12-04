import sequtils, strutils

type
  Program* = seq[int]
  Input* = object
    noun*: int
    verb*: int
  Computer* = ref object
    source: Program     # Original program code without modifications
    program*: Program   # The computers program in memory
    ic*: int            # The instruction counter

  StopExecution = object of Exception
  ## This will be raised when the ending opcode is reached
  
proc set(cp: Computer, address, value: int): void = 
  cp.program[address] = value

proc get(cp: Computer, address: int): int = 
  cp.program[address]

proc add(cp: Computer, param1, param2, param3: int): void =
  cp.set(param3, (cp.get(param1) + cp.get(param2)))

proc mul(cp: Computer, param1, param2, param3: int): void =
  cp.set(param3, (cp.get(param1) * cp.get(param2)))

proc newComputer*(sourceFile: string): Computer =  
  var file = readFile("input.txt");
  file.stripLineEnd
  let source = map(split(file, ','), parseInt)  
  result = Computer(source: source, ic: 0)

proc reset*(cp: Computer, input: Input): void =
  ## Reset instruction pointer, program code and input values
  cp.program = cp.source
  cp.ic = 0
  cp.set(1, input.noun)
  cp.set(2, input.verb)

proc process(cp: Computer): void = 
  let opCode = cp.get(cp.ic)
  if opCode == 99:   # End Execution
    raise newException(StopExecution, "Program ended")
  if opCode == 1:    # Addition
    cp.add(cp.get(cp.ic+1), cp.get(cp.ic+2), cp.get(cp.ic+3))
  if opCode == 2:    # Multiplication
    cp.mul(cp.get(cp.ic+1), cp.get(cp.ic+2), cp.get(cp.ic+3))
  cp.ic += 4

proc run*(cp: Computer): int =
  ## Runs the program loaded in memory until complete
  try:
    while true:
      cp.process
  except StopExecution:
    return cp.get(0)
  return -1   # Something went wrong

proc findInputFor*(cp: Computer, target: int): Input =
  ## Finds fitting inputs to produce the desired output
  ## Stops at the first match
  for noun in 0 .. 99:
    for verb in 0 .. 99:
      let input = Input(noun: noun, verb: verb)
      cp.reset(input)
      var output = cp.run
      if output == target:
        return input