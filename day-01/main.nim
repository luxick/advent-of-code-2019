import math, strutils

proc fuelCalc(mass: int): int = 
    floor(mass / 3).toInt - 2


proc calcForFuel(fuelMass: int): int =
    let required = fuelCalc(fuelMass)
    if required <= 0:
        return 0
    else:
        return required + calcForFuel(required)

proc calc(mass: int): int =
    var massFuel = fuelCalc(mass)
    var fuelFuel = calcForFuel(massFuel)
    return massFuel + fuelFuel

var result = 0;
var file = open("input.txt", fmRead);
for line in file.lines:
    result += calc(line.parseInt)

echo result