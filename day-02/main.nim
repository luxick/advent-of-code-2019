import computer

proc solvePart1(): void = 
  var 
    cp = newComputer("input.txt")
    input = Input(noun: 12, verb: 2)
  cp.reset(input)
  let result = cp.run
  echo "Result for Part 1: ", result

proc solvePart2(): void =
  var 
    target = 19690720
    cp = newComputer("input.txt")
    inputs = cp.findInputFor(target)
  echo "result for Part 2: ", 100 * inputs.noun + inputs.verb

solvePart1()
solvePart2()  