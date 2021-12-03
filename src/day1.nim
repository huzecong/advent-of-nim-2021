import base
import strutils, sequtils, math

type Day1* = ref object of Solution
    depths: seq[int]

proc initDay1*(path: string): Day1 =
    let lines = readFile(path).strip().splitLines()
    Day1(depths: lines.map(parseInt))

method solvePart1*(this: Day1): int =
    for i in 1 ..< this.depths.len:
        if this.depths[i - 1] < this.depths[i]:
            result += 1

method solvePart2*(this: Day1): int =
    for i in 3 ..< this.depths.len:
        if sum(this.depths[i - 3..i - 1]) < sum(this.depths[i - 2..i]):
            result += 1
