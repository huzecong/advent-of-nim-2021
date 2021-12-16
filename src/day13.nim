import sequtils, strutils, sugar
import base, utils/[board, iter, utils]

type Fold = tuple[axis: string, position: int]
type Day13* = ref object of Solution
  points: seq[Point]
  folds: seq[Fold]

proc newDay13*(path: string): Day13 =
  let blocks = readFile(path).strip.split("\n\n")
  let points = blocks[0].splitLines.mapIt(it.split(",").map(parseInt).toTuple(2))
  
  func parseFold(s: string): Fold =
    let (axis, posStr) = s.split(" ")[^1].split("=").toTuple(2)
    (axis: axis, position: parseInt(posStr))
  
  let folds = blocks[1].splitLines.map(parseFold)
  Day13(points: points, folds: folds)

func fold(fold: Fold, points: seq[Point], ): seq[Point] =
  let newPoints = collect(newSeq):
    for (x, y) in points:
      if fold.axis == "x":
        (fold.position - abs(x - fold.position), y)
      else:
        (x, fold.position - abs(y - fold.position))
  return newPoints.deduplicate

method solvePart1Int*(this: Day13): int =
  this.folds[0].fold(this.points).len

func render(points: seq[Point]): string =
  let (minX, maxX) = points.mapIt(it[0]).minMax
  let (minY, maxY) = points.mapIt(it[1]).minMax
  var board = newSeqWith(maxY - minY + 1, ' '.repeat(maxX - minX + 1))
  for (x, y) in points:
    board[y - minY][x - minX] = '#'
  return "\n" & board.join("\n")

method solvePart2*(this: Day13): string =
  let points = this.folds.foldl(b.fold(a), this.points)
  points.render
