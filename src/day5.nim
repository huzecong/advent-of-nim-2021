import strformat, strutils, sequtils, sugar, tables
import iterutils
import base, utils/[iter, utils]

type
  Point = tuple[x: int, y: int]
  Line = tuple[a: Point, b: Point]

func sign(x: int): int =
  if x > 0: 1
  elif x < 0: -1
  else: 0

iterator getPoints(line: Line): Point =
  let
    deltaX = sign(line.b.x - line.a.x)
    deltaY = sign(line.b.y - line.a.y)
  var (x, y) = line.a
  while (x, y) != line.b:
    yield (x, y)
    x += deltaX
    y += deltaY
  yield line.b

func isStraight(line: Line): bool =
  line.a.x == line.b.x or line.a.y == line.b.y

type Day5* = ref object of Solution
  lines: seq[Line]

proc newDay5*(path: string): Day5 =
  let lines = readFile(path).strip.splitLines.map(s => s.split(" -> ").map(
      s => s.split(",").map(parseInt).toTuple(2)).toTuple(2))
  Day5(lines: lines)

{.hint[XDeclaredButNotUsed]: off.}
proc print(points: Table[Point, int]): void =
  let
    (minX, maxX) = points.keys.map(xy => xy[0]).minMax
    (minY, maxY) = points.keys.map(xy => xy[1]).minMax
  echo &"({minX}, {minY}) .. ({maxX}, {maxY})"
  for x in minX .. maxX:
    let lineVals = toSeq(minY .. maxY).map(y => points.getOrDefault((x, y), 0))
    echo lineVals.map(x => (if x == 0: "." else: $x)).join("")

func countOverlaps(lines: seq[Line], onlyStraight: bool): int =
  var points = initTable[Point, int]()
  for line in lines:
    if not onlyStraight or line.isStraight:
      for point in line.getPoints:
        inc points.mgetOrPut(point, 0)
  # print points
  for v in points.values:
    if v >= 2: inc result

method solvePart1Int*(this: Day5): int =
  countOverlaps(this.lines, onlyStraight = true)

method solvePart2Int*(this: Day5): int =
  countOverlaps(this.lines, onlyStraight = false)
