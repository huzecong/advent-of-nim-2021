import algorithm, math, strutils, sequtils, sugar
import base

type Day7* = ref object of Solution
  positions: seq[int]

proc newDay7*(path: string): Day7 =
  let positions = readFile(path).strip.split(",").map(parseInt)
  Day7(positions: positions)

method solvePart1Int*(this: Day7): int =
  var positions = this.positions
  positions.sort
  let median = positions[positions.len div 2]
  return positions.map(x => abs(x - median)).sum

method solvePart2Int*(this: Day7): int =
  let x = this.positions.sum / this.positions.len

  func cost(a, b: int): int =
    let d = abs(a - b)
    return d * (d + 1) div 2

  return [floor(x), ceil(x)].map(
      pos => this.positions.map(x => cost(x, pos.int)).sum).min
