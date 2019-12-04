import math

# The puzzle input
const
  inputLow = 171309
  inputHigh = 643603

iterator digitsLowToHight(number: int): int =
  var num = number
  while (num != 0):
    yield num mod 10
    num = num.floorDiv(10)

proc hasAdjacentSame(number: int): bool =
  var previous = int.high
  for digit in number.digitsLowToHight:
    if (previous == digit):
      return true
    previous = digit
  return false

proc digitsAscending(number: int): bool =
  var previous = int.high
  for digit in number.digitsLowToHight:
    if previous < digit:
      return false
    previous = digit
  return true

proc noLargerGroups(number: int): bool =
  discard

proc countCombinations(lower, upper: int): int =
  ## Count all possible combinations between two bounds
  for num in lower .. upper:
    if (num.hasAdjacentSame and num.digitsAscending):
      result.inc

proc countCombinationsPart2(lower, upper: int): int =
  ## Count all possible combinations between two bounds
  for num in lower .. upper:
    if (num.hasAdjacentSame and num.digitsAscending and num.noLargerGroups):
      result.inc

echo "Part 1: Number of combinations with in the range  ->  ", countCombinations(inputLow, inputHigh)
echo "Part 2: Number of combinations with in the range  ->  ", countCombinationsPart2(inputLow, inputHigh)