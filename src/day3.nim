import base
import strutils, sugar

type Day3 = ref object of Solution
    lines: seq[string]
    nBits: int

proc initDay3*(path: string): Day3 =
    let lines = readFile(path).strip().splitLines()
    Day3(lines: lines, nBits: lines[0].len)

proc getMostCommonBit(lines: seq[string], i: int): char =
    var count = 0
    for x in lines:
        count += int(x[i] == '1')
    return if count * 2 >= lines.len: '1' else: '0'

method solvePart1*(this: Day3): int =
    var rates: array['0'..'1', int] = [0, 0]
    for i in 0 ..< this.nBits:
        rates['0'] *= 2
        rates['1'] *= 2
        rates[getMostCommonBit(this.lines, i)] += 1
    return rates['0'] * rates['1']

method solvePart2*(this: Day3): int =
    proc findRating(getBit: (seq[string], int) -> char): int =
        var remaining = this.lines
        for i in 0 ..< this.nBits:
            let bit = getBit(remaining, i)
            remaining = collect(newSeq):
                for line in remaining:
                    if line[i] == bit: line
            if remaining.len == 1:
                return parseBinInt(remaining[0])
        assert false

    proc revChar(c: char): char = return if c == '0': '1' else: '0'

    let oxygenRating = findRating(getMostCommonBit)
    let co2Rating = findRating((lines, i) => revChar(getMostCommonBit(lines, i)))
    return oxygenRating * co2Rating
