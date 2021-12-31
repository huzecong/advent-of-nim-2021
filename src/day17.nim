import nre, options, sequtils, strutils
import base

type
  Bounds = object
    left, right, up, down: int
  Day17* = ref object of Solution
    bounds: Bounds

const maxVelocity = 200

proc newDay17*(path: string): Day17 =
  let input = readFile(path).strip
  let matches = find(input, re"target area: x=(\d+)\.\.(\d+), y=(-?\d+)\.\.(-?\d+)").get().captures
  let xs = (0 .. 3).toSeq.mapIt(matches[it].parseInt)
  Day17(bounds: Bounds(left: xs[0], right: xs[1], down: xs[2], up: xs[3]))

func computeMaxY(bounds: Bounds, initVx, initVy: int): Option[int] =
  var
    x, y, maxY = 0
    vx = initVx
    vy = initVy
    inside = false

  proc step() =
    (x, y, vx, vy) = (x + vx, y + vy, max(0, vx - 1), vy - 1)
    maxY = max(maxY, y)

  while x <= bounds.right and (vy > 0 or y >= bounds.down):
    if bounds.left <= x and x <= bounds.right and bounds.down <= y and y <= bounds.up:
      inside = true
    step()
  if not inside:
    return none(int)
  while vy > 0:
    step()
  return some(maxY)

method solvePart1Int*(this: Day17): int =
  for vx in 1 .. maxVelocity:
    for vy in -maxVelocity .. maxVelocity:
      let maxY = this.bounds.computeMaxY(vx, vy)
      if maxY.isSome:
        result = max(result, maxY.get)

method solvePart2Int*(this: Day17): int =
  for vx in 1 .. maxVelocity:
    for vy in -maxVelocity .. maxVelocity:
      if this.bounds.computeMaxY(vx, vy).isSome:
        inc result
