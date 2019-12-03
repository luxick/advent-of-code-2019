import strutils, hashes, sets, sequtils, algorithm

type Point = object
  x: int
  y: int

type Intersection = object
  point: Point
  steps: int

proc absCmp(x, y: Point): int =
  ## Compate Points by absolute values (-3, -3) nad (3, 3) are equal
  if (x.x.abs + x.y.abs) < (y.x.abs + y.y.abs):
    return -1
  if (x.x.abs + x.y.abs) == (y.x.abs + y.y.abs):
    return 0
  return 1

proc hash(x: Point): Hash =
  ## Make Points hashable
  var h: Hash = 0
  h = h !& hash(x.x)
  h = h !& hash(x.y)
  result = !$h

proc hash(x: Intersection): Hash =
  ## Make Intersections hashable
  var h: Hash = 0
  h = h !& hash(x.point)
  h = h !& hash(x.steps)
  result = !$h

iterator inDirection(cursor: var Point, op: string): Point {.closure.} =
  ## Iterate all Points from the current cursor position to the target of the operation
  let amount = op.substr(1).parseInt
  case op[0]:   # The directional letter
    of 'U':
      for i in cursor.y + 1 .. cursor.y + amount: 
       yield Point(x: cursor.x, y: i)
      cursor.y += amount  
    of 'R':
      for i in cursor.x + 1 .. cursor.x + amount:
        yield Point(x: i, y: cursor.y)
      cursor.x += amount
    of 'D':        
      for i in countdown(cursor.y - 1, cursor.y - amount):
        yield Point(x: cursor.x, y: i)
      cursor.y -= amount
    of 'L':
      for i in countdown(cursor.x - 1, cursor.x - amount):
        yield Point(x: i, y: cursor.y)
      cursor.x -= amount
    else:
      raise newException(ValueError, "Unrecognized direction")

proc processOp(cursor: var Point, op: string, compareTo: HashSet[Point], matches: var HashSet[Intersection], steps: var int): seq[Point] =
  for point in cursor.inDirection(op):
    result.add(point)
    steps.inc
    if compareTo.contains(point):
      matches.incl(Intersection(point: point, steps: steps))

proc tracePath(line: seq[string], compareTo: HashSet[Point], matches: var HashSet[Intersection]): seq[Point] = 
  ## Moves along the path, given by the line and saves all visited locations.
  var 
    cursor = Point(x: 0, y:0)
    steps = 0
  for op in line:
    result.add(cursor.processOp(op, compareTo, matches, steps))

proc findFirstIntersection(matches1, matches2 : HashSet[Intersection]): int =
  ## Compare two sets of intersections and find the steps, woth need to reach the first intersection
  result = int.high
  for inter1 in matches1:
    for inter2 in matches2:
      if inter1.point == inter2.point and result >= inter1.steps + inter2.steps:
        result = inter1.steps + inter2.steps
  

var file = open("input.txt", fmRead)
# Assume there are only two wires
var line1 = file.readLine.split(",")
var line2 = file.readLine.split(",")

var 
  compare: HashSet[Point]
  matches: HashSet[Intersection]

var path1 = line1.tracePath(compare, matches)
var path2 = line2.tracePath(compare, matches)

var intersections: seq[Point] = path1.toHashSet.intersection(path2.toHashSet).toSeq
intersections.sort(absCmp)
let nearest = intersections[0]
echo "Part 1. Distance to nearest intersection  ->  ", nearest.x.abs + nearest.y.abs

var path1Matches: HashSet[Intersection]
var path2Matches: HashSet[Intersection]
discard line1.tracePath(intersections.toHashSet, path1Matches)
discard line2.tracePath(intersections.toHashSet, path2Matches)
echo "Part 2. Combined steps of both wires to first intersection  ->  ", findFirstIntersection(path1Matches, path2Matches)