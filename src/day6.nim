import math, strutils, sequtils
import base

type FishArray = array[0 .. 8, int]
type Day6* = ref object of Solution
  fishCount: FishArray  # fishCount[i] is the number of fishes with timer = i

proc newDay6*(path: string): Day6 =
  let fishes = readFile(path).strip.split(",").map(parseInt)
  var fishCount: FishArray
  for fish in fishes:
    inc fishCount[fish]
  Day6(fishCount: fishCount)

func simulate(initialState: FishArray, nDays: int): FishArray =
  var state = initialState
  for _ in 1 .. nDays:
    var newState: FishArray
    newState[8] = state[0]
    newState[6] = state[0]
    for i in 1 .. 8:
      newState[i - 1] += state[i]
    state = newState
  return state

method solvePart1Int*(this: Day6): int =
  simulate(this.fishCount, 80).sum

method solvePart2Int*(this: Day6): int =
  simulate(this.fishCount, 256).sum
