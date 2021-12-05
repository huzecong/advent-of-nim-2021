import base
import strutils, sequtils

type Day2* = ref object of Solution
  commands: seq[tuple[direction: string, distance: int]]

proc newDay2*(path: string): Day2 =
  proc parseLine(line: string): tuple[direction: string, distance: int] =
    let parts = line.splitWhitespace
    return (parts[0], parseInt(parts[1]))

  let lines = readFile(path).strip().splitLines()
  Day2(commands: lines.map(parseLine))

method solvePart1Int*(this: Day2): int =
  var x, y = 0
  for (direction, distance) in this.commands:
    case direction
      of "forward": x += distance
      of "down": y += distance
      of "up": y -= distance
      else: discard
  return x * y

method solvePart2Int*(this: Day2): int =
  var x, y, aim = 0
  for (direction, distance) in this.commands:
    case direction
      of "forward": x += distance; y += aim * distance
      of "down": aim += distance
      of "up": aim -= distance
      else: discard
  return x * y
